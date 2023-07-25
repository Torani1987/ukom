import 'package:flutter/material.dart';

class InputFormField extends StatelessWidget {
  InputFormField({
    super.key,
    this.validator,
    required this.controller,
    this.maxLength,
    required this.keyboardType,
    required this.hintText,
    this.helperText,
    this.suffixIcon,
  });

  final TextEditingController controller;
  int? maxLength;
  final String hintText;
  final TextInputType keyboardType;
  String? helperText;
  Widget? suffixIcon;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: validator,
        controller: controller,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          helperText: helperText,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ));
  }
}
