import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';

class InputText extends StatelessWidget {
  final Widget icon;
  final String label;
  final TextEditingController controller;
  final bool enabled = true;
  final bool obscureText;

  const InputText(
      {super.key,
      required this.icon,
      required this.label,
      required this.controller,
      required this.obscureText,
      bool enabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.blue),
        ),
        child: TextField(
          enabled: enabled,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            focusColor: AppColors.secondary,
            labelStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
            suffixIcon: icon,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
