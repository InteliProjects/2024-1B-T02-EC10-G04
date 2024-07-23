import 'package:flutter/material.dart';
import 'package:mobile/controller/user.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/services/user.dart';
import 'package:mobile/widgets/custom_button.dart';
import 'package:mobile/widgets/role_dropdown.dart';
import 'package:mobile/widgets/input_text.dart';
import 'package:mobile/widgets/password_rule.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late UserController _signUpController;
  bool isButtonEnabled = false;
  bool _showContainer = false;
  var showPassword = true;
  IconData iconType = Icons.visibility;
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    _signUpController = UserController(userService: UserService());
    _nameController.addListener(_validateInputs);
    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_onTextChanged);
  }

  void _validateInputs() {
    setState(() {
      isButtonEnabled = _emailController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          selectedRole != null &&
          _arePasswordRulesSatisfied();
      _showContainer = _passwordController.text.isNotEmpty;
    });
  }

  bool _arePasswordRulesSatisfied() {
    final rules = [
      PasswordRule(
        expression: r'[A-Z]',
        label: '1 uppercase letter',
        text: _passwordController.text,
      ),
      PasswordRule(
        expression: r'[a-z]',
        label: '1 lowercase letter',
        text: _passwordController.text,
      ),
      PasswordRule(
        expression: r'[0-9]',
        label: '1 number',
        text: _passwordController.text,
      ),
      PasswordRule(
        expression: r'[!@#$%^&*(),.?":{}|<>]',
        label: '1 special character',
        text: _passwordController.text,
      ),
      PasswordRule(
        expression: r'^.{8,}$',
        label: '8 characters',
        text: _passwordController.text,
      ),
    ];
    return rules.every((rule) => rule.isRuleSatisfied());
  }

  void _onSubmit() {
    if (isButtonEnabled) {
      _signUpController.signup(context, _nameController.text,
          _emailController.text, _passwordController.text, selectedRole!);
    }
  }

  void _onTextChanged() {
    _validateInputs();
  }

  void _onViewPassword() {
    setState(() {
      showPassword = !showPassword;
      showPassword
          ? iconType = Icons.visibility
          : iconType = Icons.visibility_off;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.black50,
                        tooltip: 'Back',
                        iconSize: 24.0,
                      ),
                      const Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                SizedBox(height: 40),
                                Text(
                                  'Create an account!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: AppColors.black50,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  'Please enter your details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black50,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      SizedBox(
                        width: constraints.maxWidth * 0.5,
                        height: constraints.maxHeight * 0.14,
                        child: Image.asset(
                          'assets/images/logo_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),
                      InputText(
                        controller: _nameController,
                        label: 'Name',
                        icon: const Icon(null),
                        obscureText: false,
                      ),
                      const SizedBox(height: 8),
                      InputText(
                        controller: _emailController,
                        label: 'E-mail',
                        icon: const Icon(Icons.email),
                        obscureText: false,
                      ),
                      const SizedBox(height: 8),
                      InputText(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: showPassword,
                        icon: IconButton(
                          icon: Icon(
                            iconType,
                            color: AppColors.black50,
                          ),
                          onPressed: _onViewPassword,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Dropdown(
                        title: 'Role',
                        items: const [
                          'Auxiliar de Enfermagem',
                          'Auxiliar de Farmácia',
                          'Gerente'
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                            _validateInputs();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _showContainer
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PasswordRule(
                                    expression: r'[A-Z]',
                                    label: '1 uppercase letter',
                                    text: _passwordController.text,
                                  ),
                                  PasswordRule(
                                    expression: r'[a-z]',
                                    label: '1 lowercase letter',
                                    text: _passwordController.text,
                                  ),
                                  PasswordRule(
                                    expression: r'[0-9]',
                                    label: '1 number',
                                    text: _passwordController.text,
                                  ),
                                  PasswordRule(
                                    expression: r'[!@#$%^&*(),.?":{}|<>]',
                                    label: '1 special character',
                                    text: _passwordController.text,
                                  ),
                                  PasswordRule(
                                    expression: r'^.{8,}$',
                                    label: '8 characters',
                                    text: _passwordController.text,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 24),
                      CustomButton(
                        icon: const Icon(Icons.arrow_forward),
                        label: 'Next',
                        receivedColor: AppColors.secondary,
                        onPressed: _onSubmit,
                        isEnabled: isButtonEnabled,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Have an account?",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: AppColors.black50,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/login');
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
