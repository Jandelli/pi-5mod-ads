import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flow_api/services/source.dart';
import 'ai_data_repository.dart';
import 'openai_service.dart';
import '../../blocs/ai/ai_bloc.dart';

final getIt = GetIt.instance;

void setupAIServices() {
  // Register core dependencies if not already registered
  if (!getIt.isRegistered<FlutterSecureStorage>()) {
    getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
  }

  if (!getIt.isRegistered<http.Client>()) {
    getIt.registerLazySingleton<http.Client>(
      () => http.Client(),
    );
  }

  // Register AI services
  getIt.registerLazySingleton<OpenAIService>(
    () => OpenAIService(
      secureStorage: getIt<FlutterSecureStorage>(),
      httpClient: getIt<http.Client>(),
    ),
  );

  // Register AI data repository factory - this will be injected with SourceService later
  getIt.registerFactoryParam<AIDataRepository, SourceService, void>(
    (sourceService, _) => AIDataRepository(sourceService),
  );

  // Register AI BLoC factory - this will be created with current SourceService
  getIt.registerFactoryParam<AiBloc, SourceService, void>(
    (sourceService, _) => AiBloc(
      openAIService: getIt<OpenAIService>(),
      dataRepository: getIt<AIDataRepository>(param1: sourceService),
    ),
  );
}

void disposeAIServices() {
  if (getIt.isRegistered<OpenAIService>()) {
    getIt<OpenAIService>().dispose();
  }
  if (getIt.isRegistered<http.Client>()) {
    getIt<http.Client>().close();
  }

  getIt.unregister<OpenAIService>();
  getIt.unregister<AIDataRepository>();
  getIt.unregister<AiBloc>();
}
