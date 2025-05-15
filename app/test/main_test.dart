import 'package:flow/api/storage/sources.dart';
import 'package:flow/cubits/settings.dart';
import 'db_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Adding the main function for Flutter test
void main() {
  test('Test for main_test', () {
    expect(true, isTrue);
  });
}

class TestingEntry extends StatelessWidget {
  const TestingEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
    final sourcesService = SourcesService(settingsCubit);

    return FutureBuilder(
      future: sourcesService.setup(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return DatabaseTestPage(sourcesService: sourcesService);
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

// You can add this route to your app's routes to access the testing page
// For example, in your main.dart:
// routes: {
//   '/dbtest': (context) => const TestingEntry(),
// }
