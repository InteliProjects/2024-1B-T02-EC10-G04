import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';

class CardMedicines extends StatelessWidget {
  final String medicine;
  final String lote;
  final bool isChecked;
  final VoidCallback onTap;

  const CardMedicines({
    super.key,
    required this.medicine,
    required this.lote,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: AppColors.grey2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Lot number: $lote',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const SizedBox(width: 1),
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  onTap();
                },
                checkColor: Colors.white,
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
