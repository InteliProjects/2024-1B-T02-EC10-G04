import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/widgets/navbar_icon.dart';
import 'package:mobile/logic/local_storage.dart';

class NavBarContainer extends StatefulWidget {
  const NavBarContainer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarContainerState createState() => _NavBarContainerState();
}

class _NavBarContainerState extends State<NavBarContainer> {
  String? role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    String? storedRole = await LocalStorageService().getValue('role');
    setState(() {
      role = storedRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
        border: Border(
          left:
              BorderSide(color: Color.fromARGB(255, 243, 243, 244), width: 0.5),
          right:
              BorderSide(color: Color.fromARGB(255, 243, 243, 244), width: 0.5),
          top:
              BorderSide(color: Color.fromARGB(255, 243, 243, 244), width: 0.5),
        ),
        color: AppColors.white50,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const NavBarIcon(
              icon: Icons.home_rounded,
              label: 'Home',
              index: 0,
              route: '/orders',
            ),
            if (role == "user" || role == "admin")
              const NavBarIcon(
                icon: Icons.new_label_rounded,
                label: 'Create',
                index: 1,
                route: '/qr-code',
              ),
            const NavBarIcon(
              icon: Icons.person,
              label: 'Profile',
              index: 2,
              route: '/profile',
            ),
            const NavBarIcon(
              icon: Icons.settings,
              label: 'Settings',
              index: 3,
              route: '/settings',
            ),
          ],
        ),
      ),
    );
  }
}
