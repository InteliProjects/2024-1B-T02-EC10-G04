import 'package:flutter/material.dart';
import 'package:mobile/controller/user.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/services/user.dart';
import 'package:mobile/widgets/custom_button.dart';
import 'package:mobile/widgets/input_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late UserController _loginController;
  bool isButtonEnabled = false;
  var showPassword = true;
  IconData iconType = Icons.visibility;

  @override
  void initState() {
    super.initState();
    _loginController = UserController(userService: UserService());
    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    setState(() {
      isButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  void _onSubmit() {
    if (isButtonEnabled) {
      _loginController.login(
          context, _emailController.text, _passwordController.text);
    }
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
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'Welcome Back!',
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
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: AppColors.grey3,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        icon: const Icon(Icons.arrow_forward),
                        label: 'Submit',
                        receivedColor: AppColors.secondary,
                        onPressed: _onSubmit,
                        isEnabled: isButtonEnabled,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.black50)),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/signup');
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
