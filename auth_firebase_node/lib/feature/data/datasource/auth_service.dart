import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:auth_firebase_node/feature/domain/model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String baseUrl = 'http://192.168.1.8:3000/api';

  Stream<User?> get authChanges => _auth.authStateChanges();

  Future<String> _getIdToken() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');
    return await user.getIdToken() ?? '';
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    User? firebaseUser;

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser = userCredential.user!;

      final token = await firebaseUser.getIdToken();

      final registerResponse = await http
          .post(
            Uri.parse('$baseUrl/users/register'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'name': name}),
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Backend registration timeout');
            },
          );

      if (registerResponse.statusCode != 201) {
        String errorMessage = 'Registration failed';
        try {
          final error = jsonDecode(registerResponse.body);
          errorMessage = error['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'Backend error: ${registerResponse.statusCode}';
        }

        await firebaseUser.delete();

        throw Exception(errorMessage);
      }

      return UserModel(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        profileCompleted: false,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      if (firebaseUser != null) {
        try {
          await firebaseUser.delete();
        } catch (deleteError) {
          throw Error;
        }
      }

      throw Exception(e.toString());
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      final token = await user.getIdToken();

      final response = await http
          .get(
            Uri.parse('$baseUrl/users/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Profile fetch timeout');
            },
          );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch profile');
      }

      final data = jsonDecode(response.body);

      return UserModel.fromMap(data['data']);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      final token = await _getIdToken();

      final response = await http
          .get(
            Uri.parse('$baseUrl/users/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw Exception('User fetch timeout');
            },
          );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch user');
      }

      final data = jsonDecode(response.body);
      return UserModel.fromMap(data['data']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> completeProfile({
    required String name,
    required File imageFile,
  }) async {
    try {
      final fileExists = await imageFile.exists();

      if (!fileExists) {
        throw Exception('Image file does not exist');
      }

      final fileName = imageFile.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();

      final validExtensions = [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
        'heic',
        'heif',
      ];
      if (!validExtensions.contains(extension)) {
        throw Exception(
          'Invalid file type. Please select a valid image (JPG, PNG, GIF, WEBP)',
        );
      }

      final token = await _getIdToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/users/complete'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = name;

      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: fileName,
        contentType: MediaType(
          'image',
          extension == 'jpg' ? 'jpeg' : extension,
        ),
      );

      request.files.add(multipartFile);

      final streamedResponse = await request.send().timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Profile completion timeout');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        String errorMessage = 'Profile completion failed';
        try {
          final error = jsonDecode(response.body);
          errorMessage = error['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'Server error: ${response.statusCode}';
        }

        throw Exception(errorMessage);
      }

      final data = jsonDecode(response.body);

      return UserModel.fromMap(data['data']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password is too weak';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return e.message ?? 'Authentication error';
    }
  }
}
