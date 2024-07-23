import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';
import 'package:provider/provider.dart';
import 'package:mobile/logic/navbar_state.dart';

class NavBarIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final String route;

  const NavBarIcon(
      {super.key,
      required this.icon,
      required this.label,
      required this.index,
      required this.route});

  @override
  Widget build(context) {
    final navBarState = Provider.of<NavBarState>(context);
    final isSelected = index == navBarState.selectedIndex;

    return GestureDetector(
      onTap: () {
        if (ModalRoute.of(context)!.settings.name != route) {
          navBarState.setSelectedIndex(index);
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),                  
                ),
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 14.0, right: 14.0),
                child: Icon(icon,
                    size: 25,
                    color: isSelected
                        ? AppColors.white100
                        : AppColors.grey3)),
            Text(
              label,
              style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.grey3,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
