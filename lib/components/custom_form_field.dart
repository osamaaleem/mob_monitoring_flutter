import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.tec,
    required this.hint,
    this.helperText,
    this.obscure = false,
    required this.keyboardType
  });

  final TextEditingController tec;
  final String hint;
  final bool obscure;
  final String? helperText;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value){
        if(value == null || value.isEmpty){
          return 'Please Enter $hint';
        }
        return null;
      },
      obscureText: obscure,
      keyboardType: keyboardType,
      controller: tec,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: hint,
        helperText: helperText
      ),
      onSaved: (value){
        tec.text = value!;
      },
    );
  }
}