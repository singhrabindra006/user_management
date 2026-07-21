import 'package:auth_firebase_node/feature/presentation/bloc/auth_bloc.dart';
import 'package:auth_firebase_node/feature/presentation/widgets/my_button.dart';
import 'package:auth_firebase_node/feature/presentation/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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
                  content: Text("Register Successfully"),
                ),
              );
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              MyTextfield(
                textController: nameController,
                hintText: 'Enter Name',
                prefixIcon: Icon(Icons.person),
              ),
              SizedBox(height: 14),
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
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return MyButton(
                      isLoging: state.authStatus == AuthStatus.loading
                          ? true
                          : false,
                      btnText: 'REGISTER',
                      onPressed: state.authStatus == AuthStatus.loading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                RegisterEvent(
                                  nameController.text.trim(),
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
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Login',
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
