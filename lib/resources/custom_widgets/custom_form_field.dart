import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String? labelText;
  final TextInputType? keyboardType;
  final Function(String)? onChangedMethod;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const CustomFormField({
    super.key,
    this.labelText,
    this.keyboardType,
    this.onChangedMethod,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Card(
        elevation: 6,
        child: TextFormField(
          controller: controller,
          validator: validator ?? (val) {},
          onChanged: onChangedMethod ?? (val) {},
          keyboardType: keyboardType ?? TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: labelText ?? '',
            labelStyle: const TextStyle(color: Colors.white),
            fillColor: Colors.blueGrey[600],
            filled: true,
          ),
        ),
      ),
    );
  }
}
