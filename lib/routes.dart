import 'package:flutter/material.dart';

class RouteConstants {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.splash:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
        );
      case RouteConstants.login:
        // Return login screen route
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(body: Center(child: Text('Login Screen'))),
        );
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
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
