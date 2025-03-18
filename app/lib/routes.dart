// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class RouteConstants {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login page after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(RouteConstants.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'AplicAI',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteConstants.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteConstants.register:
        // Return register screen route
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Register Screen'))),
        );
      case RouteConstants.home:
        // Return home screen route
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(body: Center(child: Text('Home Screen'))),
        );
      case RouteConstants.profile:
        // Return profile screen route
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Profile Screen'))),
        );
      default:
        // Return error screen route for undefined routes
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                appBar: AppBar(title: const Text('Not Found')),
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
