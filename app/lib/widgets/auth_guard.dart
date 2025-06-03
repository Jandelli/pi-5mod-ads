import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/registration_page.dart';
import '../helpers/auth_error_handler.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _showRegistration = false;

  void _toggleAuthMode() {
    setState(() {
      _showRegistration = !_showRegistration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          // Display error snackbar on auth failures
          AuthErrorHandler.showErrorSnackbar(context, state.message);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial || state is AuthLoading) {
            return const _SplashScreen();
          } else if (state is AuthAuthenticated) {
            return widget.child;
          } else {
            // Use a nested Navigator to provide an Overlay for tooltips and snackbars
            final page = _showRegistration
                ? RegistrationPage(onBackToLogin: _toggleAuthMode)
                : LoginPage(onCreateAccount: _toggleAuthMode);
            // Ensure Navigator rebuilds when toggling auth mode
            return Navigator(
              key: ValueKey(_showRegistration),
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (ctx) => BlocProvider.value(
                  value: context.read<AuthBloc>(),
                  child: page,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.trending_up,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Momentum',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
