import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';

class DayCard extends StatelessWidget {
  final String day;
  final String weekDay;
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DayCard({
    super.key,
    required this.day,
    required this.weekDay,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : null,
          borderRadius: BorderRadius.circular(8),
          border:
              isSelected ? null : Border.all(color: AppColors.grey2, width: 1),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Text(
              weekDay,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 10,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
