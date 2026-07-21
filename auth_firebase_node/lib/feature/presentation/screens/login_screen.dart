import 'package:auth_firebase_node/feature/presentation/bloc/auth_bloc.dart';
import 'package:auth_firebase_node/feature/presentation/screens/register_screen.dart';
import 'package:auth_firebase_node/feature/presentation/screens/reset_password_screen.dart';
import 'package:auth_firebase_node/feature/presentation/widgets/my_button.dart';
import 'package:auth_firebase_node/feature/presentation/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.authStatus == AuthStatus.failure) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.message.toString()),
                ),
              );
          }
          if (state.authStatus == AuthStatus.loaded) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Login Successful!'),
                ),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              MyTextfield(
                textController: emailController,
                hintText: 'Enter Email',
                prefixIcon: Icon(Icons.email),
              ),
              SizedBox(height: 14),
              MyTextfield(
                textController: passwordController,
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
                obscureText: true,
              ),
              SizedBox(height: 14),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return MyButton(
                      isLoging: state.authStatus == AuthStatus.loading
                          ? true
                          : false,
                      btnText: 'LOGIN',
                      onPressed: state.authStatus == AuthStatus.loading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                LoginEvent(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                ),
                              );
                            },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register new account?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
