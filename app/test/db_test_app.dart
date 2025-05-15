import 'package:flow/cubits/settings.dart';
import 'main_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Get SharedPreferences instance
  final prefs = await SharedPreferences.getInstance();

  // Run app with the SharedPreferences instance
  runApp(DatabaseTestApp(prefs: prefs));
}

class DatabaseTestApp extends StatelessWidget {
  final SharedPreferences prefs;

  const DatabaseTestApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingsCubit>(
          create: (_) => SettingsCubit(prefs),
        ),
      ],
      child: MaterialApp(
        title: 'Flow Database Testing',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const TestingEntry(),
      ),
    );
  }
}
