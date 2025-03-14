import 'package:flutter/foundation.dart';

class WebErrorHandler {
  static void initialize() {
    if (kIsWeb) {
      // Listen for errors in web context
      // This can help debug issues that might be causing white screens
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        if (kDebugMode) {
          print('Flutter error caught: ${details.exception}');
          print('Stack trace: ${details.stack}');
        }
      };
    }
  }
}
