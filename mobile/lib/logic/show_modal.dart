import 'package:flutter/material.dart';
import 'package:mobile/widgets/modal.dart';

void showModal(BuildContext context, String title, String description,
    IconData icon, Color iconColor, String routeName) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5), // Semitransparent background
    builder: (
      BuildContext context,
    ) {
      return Modal(
        title: title,
        description: description,
        icon: icon,
        iconColor: iconColor,
        routeName: routeName,
      );
    },
  );
}
