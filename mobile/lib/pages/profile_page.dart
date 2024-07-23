import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mobile/logic/local_storage.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/widgets/navbar.dart';
import 'package:mobile/widgets/input_text.dart';
import 'package:mobile/widgets/custom_button.dart';
import 'package:mobile/logic/navbar_state.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String profession = '';
  String initials = '';

  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with empty values
    _nameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');

    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    name = await LocalStorageService().getValue('name') ?? '';
    email = await LocalStorageService().getValue('email') ?? '';
    profession = await LocalStorageService().getValue('profession') ?? '';

    // Update the controllers with the values obtained
    setState(() {
      _nameController.text = name;
      _emailController.text = email;
      initials = getInitials(name);
    });
  }

  String getInitials(String name) {
    List<String> nameParts =
        name.trim().split(' ').where((part) => part.isNotEmpty).toList();
    String initials = '';
    if (nameParts.isNotEmpty) {
      initials = nameParts.map((part) => part[0]).take(2).join();
    }
    return initials.toUpperCase();
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navBarState = Provider.of<NavBarState>(context);

    Future<void> logout() async {
      await LocalStorageService().cleanValues();
      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/login');
        navBarState.setSelectedIndex(0);
      }
    }

    String initials = getInitials(name);
    Color avatarColor = getRandomColor();

    return Scaffold(
      bottomNavigationBar: const NavBarContainer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.only(top: 60.0, bottom: 15.0, left: 20.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: AppColors.black50,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Here you can see your personal information',
                      style: TextStyle(
                        color: AppColors.black50,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35.0,
                    backgroundColor: avatarColor,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    profession,
                    style: const TextStyle(
                      color: AppColors.black50,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25.0, top: 40.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Information',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
              child: Column(
                children: [
                  InputText(
                    enabled: false,
                    icon: const Icon(Icons.email),
                    label: 'Name',
                    obscureText: false,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20.0),
                  InputText(
                    enabled: false,
                    icon: const Icon(Icons.lock),
                    label: 'Email',
                    obscureText: false,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 60.0),
                  CustomButton(
                    receivedColor: AppColors.secondary,
                    isEnabled: true,
                    label: 'LogOut',
                    onPressed: () async {
                      logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
