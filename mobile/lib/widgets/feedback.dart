import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';

class Feedback extends StatelessWidget {
  final Widget icon;
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String description; // Adiciona o título de descrição

  const Feedback({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.enabled = true,
    required this.description, // Parâmetro de descrição
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Adiciona padding ao redor do widget
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description, // Exibe a descrição
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0), // Espaço entre a descrição e o campo de texto
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.blue),
            ),
            child: TextField(
              enabled: enabled,
              controller: controller,
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
        ],
      ),
    );
  }
}
