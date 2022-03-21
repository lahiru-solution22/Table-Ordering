import 'package:flutter/material.dart';

class RoundedTextFormField extends StatelessWidget {
  const RoundedTextFormField({
    Key? key,
    this.controller,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.inputFormatters,
  }) : super(key: key);

  final TextEditingController? controller;
  final String hintText;
  final String labelText;
  final bool? obscureText;
  final validator;
  final inputFormatters;
  final readOnly;
  final onTap;
  final suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText!,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: suffixIcon
      ),
      validator: validator,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
