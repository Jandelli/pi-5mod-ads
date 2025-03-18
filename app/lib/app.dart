import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/color_constants.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/authentication/bloc/auth_bloc.dart';
import 'routes.dart';
import 'core/di/injection_container.dart' as di;

class AplicAI extends StatelessWidget {
  const AplicAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (context) => AuthBloc(
                authRepository: di.sl<AuthRepository>(),
                signInWithEmail: di.sl(),
                signInWithGoogle: di.sl(),
                signUp: di.sl(),
                signOut: di.sl(),
              )..add(CheckAuthStatusEvent()),
        ),
        // Add other global BLoCs here
      ],
      child: MaterialApp(
        title: 'AplicAI',
        theme: ThemeData(
          primaryColor: ColorConstants.primaryColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: ColorConstants.primaryColor,
            secondary: ColorConstants.accentColor,
          ),
          fontFamily: 'Poppins',
          useMaterial3: true,
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: RouteConstants.splash,
        builder: (context, child) {
          // Add error handling for the entire app
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return Scaffold(
              body: Center(
                child: Text(
                  'An error has occurred.\n${errorDetails.exception}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          };
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
