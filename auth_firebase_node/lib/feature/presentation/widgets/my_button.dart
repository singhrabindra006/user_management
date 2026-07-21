import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String btnText;
  final bool isLoging;
  final void Function()? onPressed;
  const MyButton({
    super.key,
    required this.btnText,
    this.onPressed,
    this.isLoging = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isLoging
          ? CircularProgressIndicator()
          : Text(
              btnText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
    );
  }
}
