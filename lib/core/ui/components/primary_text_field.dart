import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType textInputType;
  final int maxLine;

  const PrimaryTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.textInputType = TextInputType.text,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        maxLines: maxLine,
        decoration: InputDecoration(
          // labelText: "habit title",
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
