import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/widgets/navbar.dart';
import 'package:mobile/widgets/input_text.dart';
import 'package:mobile/widgets/password_rule.dart';
import 'package:mobile/widgets/custom_button.dart';
import 'package:mobile/controller/user.dart';
import 'package:mobile/services/user.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _newPasswordController =
      TextEditingController();
  late TextEditingController _repeatedPassword = TextEditingController();
  late UserController _userController; 
  bool _showContainer = false;
  bool _isUpperCase = false;
  bool _isLowerCase = false;
  bool _isNumber = false;
  bool _isSpecialChar = false;
  bool _isMinLength = false;
  bool _isButtonEnabled = false;
  bool _isPasswordsMatch = false;
  var showPreviousPassword = true;
  var showNewPassword = true;
  IconData iconType = Icons.visibility;

  @override
  void initState() {
    super.initState();
    _userController = UserController(userService: UserService());
    _newPasswordController = TextEditingController();
    _repeatedPassword = TextEditingController();
    _newPasswordController.addListener(_onTextChanged);
    _repeatedPassword.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _repeatedPassword.dispose();
    super.dispose();
  }

  void _onViewPreviousPassword() {
    setState(() {
      showPreviousPassword = !showPreviousPassword;
      showPreviousPassword
          ? iconType = Icons.visibility
          : iconType = Icons.visibility_off;
    });
  }

  void _onViewNewPassword() {
    setState(() {
      showNewPassword = !showNewPassword;
      showNewPassword
          ? iconType = Icons.visibility
          : iconType = Icons.visibility_off;
    });
  }

  void _updatePassword() {
    if (_isButtonEnabled) {
      _userController.updatePassword(
          context, _repeatedPassword.text);
    }
  }

  void _onTextChanged() {
    setState(() {
      final newPassword = _newPasswordController.text;
      setState(() {
      _showContainer = newPassword.isNotEmpty;
      _isUpperCase = RegExp(r'[A-Z]').hasMatch(newPassword);
      _isLowerCase = RegExp(r'[a-z]').hasMatch(newPassword);
      _isNumber = RegExp(r'[0-9]').hasMatch(newPassword);
      _isSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(newPassword);
      _isMinLength = newPassword.length >= 8;
      _isPasswordsMatch = _newPasswordController.text == _repeatedPassword.text;
      _isButtonEnabled = _isUpperCase && _isLowerCase && _isNumber && _isSpecialChar && _isMinLength && _isPasswordsMatch;
    });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const NavBarContainer(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  padding: const EdgeInsets.only(
                      top: 60.0, bottom: 15.0, left: 20.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                            color: AppColors.black50,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                    ],
                  )),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25.0, top: 40.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        'Update Password',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  InputText(
                    icon: IconButton(
                          icon: Icon(
                            iconType,
                            color: AppColors.black50,
                          ),
                          onPressed: _onViewPreviousPassword,
                        ),
                    label: 'New Password',
                    controller: _newPasswordController,
                    obscureText: showPreviousPassword,
                  ),
                  const SizedBox(height: 16.0),
                  InputText(
                    icon: IconButton(
                          icon: Icon(
                            iconType,
                            color: AppColors.black50,
                          ),
                          onPressed: _onViewNewPassword,
                        ),
                    label: 'Password again',
                    controller: _repeatedPassword,
                    obscureText: showNewPassword,
                  ),
                  const SizedBox(height: 16.0),
                  _showContainer
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PasswordRule(
                                expression: r'[A-Z]',
                                label: '1 uppercase letter',
                                text: _newPasswordController.text,
                              ),
                              PasswordRule(
                                expression: r'[a-z]',
                                label: '1 lowercase letter',
                                text: _newPasswordController.text,
                              ),
                              PasswordRule(
                                expression: r'[0-9]',
                                label: '1 number',
                                text: _newPasswordController.text,
                              ),
                              PasswordRule(
                                expression: r'[!@#$%^&*(),.?":{}|<>]',
                                label: '1 special character',
                                text: _newPasswordController.text,
                              ),
                              PasswordRule(
                                expression: r'^.{8,}$',
                                label: '8 characters',
                                text: _newPasswordController.text,
                              ),
                              if(_isPasswordsMatch)
                              const PasswordRule(
                                expression: "a",
                                label: 'Passwords match',
                                text: "a",
                              )
                              else
                              const PasswordRule(
                                expression: "a",
                                label: 'Passwords match',
                                text: "b",
                              )
                            ],
                          ))
                      : const SizedBox(),
                  const SizedBox(height: 16.0),
                  CustomButton(
                    receivedColor: AppColors.secondary,
                    isEnabled: _isButtonEnabled,
                    label: 'Submit',
                    onPressed: _updatePassword,
                  )
                ],
              ),
            )
          ],
        )));
  }
}
