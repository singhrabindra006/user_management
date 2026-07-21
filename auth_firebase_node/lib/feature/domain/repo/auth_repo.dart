import 'dart:io';
import 'package:auth_firebase_node/feature/domain/model/user_model.dart';

abstract class AuthRepo {
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> login(String email, String password);

  Future<void> resetPassword(String email);

  Future<void> logout();

  Future<UserModel> getUser(String uid);

  Future<UserModel> completeProfile({
    required String name,
    required File imageFile,
  });
}
