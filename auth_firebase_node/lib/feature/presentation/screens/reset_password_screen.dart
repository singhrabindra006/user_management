import 'package:auth_firebase_node/feature/presentation/bloc/auth_bloc.dart';
import 'package:auth_firebase_node/feature/presentation/widgets/my_button.dart';
import 'package:auth_firebase_node/feature/presentation/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

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
          if (state.authStatus == AuthStatus.resetState) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    'Password reset link has been sent to your email!',
                  ),
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
                'Reset Password',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              MyTextfield(
                textController: emailController,
                hintText: 'Enter Email',
                prefixIcon: Icon(Icons.email),
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
                      btnText: "Send Reset Link",
                      onPressed: state.authStatus == AuthStatus.loading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                ResetPasswordEvent(emailController.text.trim()),
                              );
                            },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Go to login screen',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
