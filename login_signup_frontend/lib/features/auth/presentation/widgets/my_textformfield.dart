import 'package:flutter/material.dart';

class MyTextformfield extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String hintText;
  final bool obscureText;

  const MyTextformfield({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        validator: validator,
      ),
    );
  }
}
