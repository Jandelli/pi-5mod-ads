import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flow_api/services/source.dart';

import '../services/ai/openai_service.dart';
import '../services/ai/ai_data_repository.dart';
import '../blocs/ai/ai_bloc.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Register core dependencies
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  serviceLocator.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  // Register AI services
  serviceLocator.registerLazySingleton<OpenAIService>(
    () => OpenAIService(
      secureStorage: serviceLocator<FlutterSecureStorage>(),
      httpClient: serviceLocator<http.Client>(),
    ),
  );

  // Register AI data repository - this will be injected with SourceService later
  serviceLocator.registerFactoryParam<AIDataRepository, SourceService, void>(
    (sourceService, _) => AIDataRepository(sourceService),
  );

  // Register AI BLoC factory - this will be created with current SourceService
  serviceLocator.registerFactoryParam<AiBloc, SourceService, void>(
    (sourceService, _) => AiBloc(
      openAIService: serviceLocator<OpenAIService>(),
      dataRepository: serviceLocator<AIDataRepository>(param1: sourceService),
    ),
  );
}

void disposeServiceLocator() {
  serviceLocator<OpenAIService>().dispose();
  serviceLocator<http.Client>().close();
}
