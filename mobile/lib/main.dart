import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/logic/calendar_funcitons.dart';
import 'package:mobile/logic/navbar_state.dart';
import 'package:mobile/pages/orders_page.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/pages/logo_page.dart';
import 'package:mobile/pages/onboarding_page.dart';
import 'package:mobile/pages/signup_page.dart';
import 'package:mobile/pages/profile_page.dart';
import 'package:mobile/pages/new_orders_page.dart';
import 'package:mobile/pages/check_orders_page.dart';
import 'package:mobile/pages/qr_code.dart';
import 'package:mobile/pages/settings_page.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env.front");
  } catch (error) {
    print("Error loading .env.front file: $error");
  } finally {
    runApp(const HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalendarLogic()),
        ChangeNotifierProvider(create: (_) => NavBarState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //initialRoute: '/orders',
        home: const SplashScreen(),
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          NewOrderPage.routeName: (context) => const NewOrderPage(),
          CheckOrderPage.routeName: (context) => const CheckOrderPage(),
          '/orders': (BuildContext context) => const OrdersPage(),
          '/profile': (context) => const ProfilePage(),
          '/qr-code': (context) => const QRCodePage(),
          '/settings': (context) => const SettingsPage(),
        },
      ),
    );
  }
}
