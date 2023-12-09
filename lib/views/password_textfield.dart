import 'package:bloc_notes/strings.dart' show enterYourPasswordHere;
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;
  const PasswordTextField({
    super.key,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscuringCharacter: '🙈',
      autocorrect: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: enterYourPasswordHere,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
