import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextfield extends StatelessWidget {
  CustomTextfield({super.key, required this.hint, this.onChange,this.obsecureText=false});

  final String hint;
  Function(String)? onChange;
  final bool obsecureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecureText,
      validator: (value) {
        if (value!.isEmpty) return "Field is required!";
        return null;
      },
      onChanged: onChange,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10))),
    );
  }
}
