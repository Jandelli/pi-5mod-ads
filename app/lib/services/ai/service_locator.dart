import 'package:get_it/get_it.dart';
import 'package:flow/services/ai/openai_service.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupAIServices() async {
  // Register AI services
  serviceLocator.registerLazySingleton<OpenAIService>(() => OpenAIService());
}

// Convenience getters
OpenAIService get openAIService => serviceLocator<OpenAIService>();
