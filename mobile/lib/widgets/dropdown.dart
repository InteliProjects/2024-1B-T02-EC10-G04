import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';

class Dropdown extends StatefulWidget {
  final ValueChanged<String?>? onChanged;

  const Dropdown({super.key, this.onChanged});

  @override
  // ignore: library_private_types_in_public_api
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? selectedRole;
  final List<String> roles = ['No, thanks!', 'Yes, please!'];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.grey2), 
          bodySmall: TextStyle(fontFamily: 'Poppins', color: AppColors.grey2), 
        ),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          labelText: 'Answer',
          labelStyle: const TextStyle(fontFamily: 'Poppins'),
        ),
        value: selectedRole,
        icon: const Icon(Icons.arrow_drop_down),
        items: roles.map((role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRole = value;
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          });
        },
      ),
    );
  }
}
