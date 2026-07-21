import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final Icon prefixIcon;
  final bool obscureText;
  const MyTextfield({
    super.key,
    required this.textController,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: textController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
