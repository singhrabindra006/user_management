import 'package:auth_firebase_node/feature/data/datasource/auth_service.dart';
import 'package:auth_firebase_node/feature/data/repo_impl/auth_repo_impl.dart';
import 'package:auth_firebase_node/feature/presentation/bloc/auth_bloc.dart';
import 'package:auth_firebase_node/feature/presentation/screens/auth_gate.dart';
import 'package:auth_firebase_node/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthRepoImpl(AuthService())),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: AuthGate()),
    );
  }
}
