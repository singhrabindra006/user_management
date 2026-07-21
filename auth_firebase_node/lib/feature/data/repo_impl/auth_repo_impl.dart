import 'dart:io';
import 'package:auth_firebase_node/feature/data/datasource/auth_service.dart';
import 'package:auth_firebase_node/feature/domain/repo/auth_repo.dart';
import 'package:auth_firebase_node/feature/domain/model/user_model.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthService authService;
  AuthRepoImpl(this.authService);

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) {
    return authService.register(name: name, email: email, password: password);
  }

  @override
  Future<UserModel> login(String email, String password) {
    return authService.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return authService.logout();
  }

  @override
  Future<void> resetPassword(String email) {
    return authService.resetPassword(email);
  }

  @override
  Future<UserModel> getUser(String uid) {
    return authService.getUser(uid);
  }

  @override
  Future<UserModel> completeProfile({
    required String name,
    required File imageFile,
  }) {
    return authService.completeProfile(name: name, imageFile: imageFile);
  }
}
