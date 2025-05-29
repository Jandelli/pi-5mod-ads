import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/ai/ai_models.dart';
import '../../services/ai/ai_data_repository.dart';
import '../../services/ai/openai_service.dart';

// Events
abstract class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object?> get props => [];
}

class AiGenerateSummaryRequested extends AiEvent {
  final AISummaryTimeframe timeframe;
  final DateTime? customStartDate;
  final DateTime? customEndDate;

  const AiGenerateSummaryRequested({
    required this.timeframe,
    this.customStartDate,
    this.customEndDate,
  });

  @override
  List<Object?> get props => [timeframe, customStartDate, customEndDate];
}

class AiSetApiKeyRequested extends AiEvent {
  final String apiKey;

  const AiSetApiKeyRequested(this.apiKey);

  @override
  List<Object> get props => [apiKey];
}

class AiClearApiKeyRequested extends AiEvent {}

class AiCheckApiKeyRequested extends AiEvent {}

class AiRefreshRequested extends AiEvent {}

// States
abstract class AiState extends Equatable {
  const AiState();

  @override
  List<Object?> get props => [];
}

class AiInitial extends AiState {}

class AiLoading extends AiState {
  final String? message;

  const AiLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class AiLoaded extends AiState {
  final AISummaryResponse summary;
  final bool hasApiKey;

  const AiLoaded({
    required this.summary,
    required this.hasApiKey,
  });

  @override
  List<Object> get props => [summary, hasApiKey];
}

class AiError extends AiState {
  final String message;
  final bool hasApiKey;

  const AiError({
    required this.message,
    required this.hasApiKey,
  });

  @override
  List<Object> get props => [message, hasApiKey];
}

class AiApiKeyConfigured extends AiState {
  final bool hasApiKey;

  const AiApiKeyConfigured({required this.hasApiKey});

  @override
  List<Object> get props => [hasApiKey];
}

// BLoC
class AiBloc extends Bloc<AiEvent, AiState> {
  final AIDataRepository _dataRepository;
  final OpenAIService _openAIService;

  AiBloc({
    required AIDataRepository dataRepository,
    required OpenAIService openAIService,
  })  : _dataRepository = dataRepository,
        _openAIService = openAIService,
        super(AiInitial()) {
    on<AiGenerateSummaryRequested>(_onGenerateSummaryRequested);
    on<AiSetApiKeyRequested>(_onSetApiKeyRequested);
    on<AiClearApiKeyRequested>(_onClearApiKeyRequested);
    on<AiCheckApiKeyRequested>(_onCheckApiKeyRequested);
    on<AiRefreshRequested>(_onRefreshRequested);

    // Check API key status on initialization
    add(AiCheckApiKeyRequested());
  }

  Future<void> _onGenerateSummaryRequested(
    AiGenerateSummaryRequested event,
    Emitter<AiState> emit,
  ) async {
    emit(const AiLoading(message: 'Coletando seus dados...'));

    try {
      // Check if API key is configured
      final hasApiKey = await _openAIService.hasApiKey();
      if (!hasApiKey) {
        emit(const AiError(
          message:
              'Chave da API do OpenAI não configurada. Configure sua chave para usar o resumo de IA.',
          hasApiKey: false,
        ));
        return;
      }

      // Collect user data
      emit(const AiLoading(message: 'Coletando eventos e notas...'));
      final request = await _dataRepository.collectUserData(
        timeframe: event.timeframe,
        customStartDate: event.customStartDate,
        customEndDate: event.customEndDate,
      );

      // Check if there's any data to summarize
      if (request.events.isEmpty &&
          request.notes.isEmpty &&
          request.upcomingTasks.isEmpty) {
        emit(AiError(
          message:
              'Nenhum dado encontrado para o período selecionado. Tente adicionar alguns eventos ou notas primeiro.',
          hasApiKey: hasApiKey,
        ));
        return;
      }

      // Generate AI summary
      emit(const AiLoading(message: 'Gerando resumo com IA...'));
      final summary = await _openAIService.generateSummary(request);

      emit(AiLoaded(
        summary: summary,
        hasApiKey: hasApiKey,
      ));
    } catch (e) {
      final hasApiKey = await _openAIService.hasApiKey();
      emit(AiError(
        message: _getErrorMessage(e),
        hasApiKey: hasApiKey,
      ));
    }
  }

  Future<void> _onSetApiKeyRequested(
    AiSetApiKeyRequested event,
    Emitter<AiState> emit,
  ) async {
    emit(const AiLoading(message: 'Configurando chave da API...'));

    try {
      await _openAIService.setApiKey(event.apiKey);
      emit(const AiApiKeyConfigured(hasApiKey: true));
    } catch (e) {
      emit(AiError(
        message: 'Erro ao configurar chave da API: ${e.toString()}',
        hasApiKey: false,
      ));
    }
  }

  Future<void> _onClearApiKeyRequested(
    AiClearApiKeyRequested event,
    Emitter<AiState> emit,
  ) async {
    try {
      await _openAIService.clearApiKey();
      emit(const AiApiKeyConfigured(hasApiKey: false));
    } catch (e) {
      emit(AiError(
        message: 'Erro ao remover chave da API: ${e.toString()}',
        hasApiKey: false,
      ));
    }
  }

  Future<void> _onCheckApiKeyRequested(
    AiCheckApiKeyRequested event,
    Emitter<AiState> emit,
  ) async {
    try {
      final hasApiKey = await _openAIService.hasApiKey();
      emit(AiApiKeyConfigured(hasApiKey: hasApiKey));
    } catch (e) {
      emit(const AiError(
        message: 'Erro ao verificar configuração da API',
        hasApiKey: false,
      ));
    }
  }

  Future<void> _onRefreshRequested(
    AiRefreshRequested event,
    Emitter<AiState> emit,
  ) async {
    add(AiCheckApiKeyRequested());
  }

  String _getErrorMessage(dynamic error) {
    final errorMessage = error.toString();

    if (errorMessage.contains('API key')) {
      return 'Problema com a chave da API do OpenAI. Verifique se ela está correta.';
    } else if (errorMessage.contains('Network')) {
      return 'Problema de conexão. Verifique sua internet e tente novamente.';
    } else if (errorMessage.contains('Rate limit')) {
      return 'Limite de uso da API excedido. Tente novamente mais tarde.';
    } else if (errorMessage.contains('Failed to collect')) {
      return 'Erro ao coletar seus dados. Tente novamente.';
    } else {
      return 'Erro inesperado ao gerar resumo. Tente novamente.';
    }
  }

  @override
  Future<void> close() {
    _openAIService.dispose();
    return super.close();
  }
}
