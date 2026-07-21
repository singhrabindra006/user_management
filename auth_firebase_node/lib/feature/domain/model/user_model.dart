import 'dart:convert';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final bool profileCompleted; // ✅ NEW
  final String? profileImageBase64; // ✅ NEW - for displaying image

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileCompleted = false,
    this.profileImageBase64,
  });

  // ✅ ADDED - Helper method to get image bytes for display
  Uint8List? get imageBytes {
    if (profileImageBase64 == null || profileImageBase64!.isEmpty) {
      return null;
    }
    try {
      return base64Decode(profileImageBase64!);
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    profileCompleted,
    profileImageBase64,
  ];

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    bool? profileCompleted,
    String? profileImageBase64,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'profile_completed': profileCompleted,
      'profile_image_base64': profileImageBase64,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['firebase_uid'] as String,
      name: (map['name'] ?? '') as String,
      email: map['email'] as String,
      profileCompleted: (map['profile_completed'] ?? false) as bool,
      profileImageBase64: map['profile_image_base64'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
