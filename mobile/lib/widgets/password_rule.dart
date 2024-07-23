import 'package:flutter/material.dart';

class PasswordRule extends StatelessWidget {
  final String text;
  final String expression;
  final String label;

  const PasswordRule({
    super.key,
    required this.text,
    required this.expression,
    required this.label,
  });

  bool isRuleSatisfied() {
    return text.contains(RegExp(expression));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isRuleSatisfied()
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : const Icon(
                Icons.block,
                color: Colors.red,
              ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
