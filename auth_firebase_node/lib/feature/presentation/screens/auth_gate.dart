import 'package:auth_firebase_node/feature/data/datasource/auth_service.dart';
import 'package:auth_firebase_node/feature/presentation/screens/login_screen.dart';
import 'package:auth_firebase_node/feature/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authChnages = AuthService().authChanges;
    return StreamBuilder(
      stream: authChnages,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProfileScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
