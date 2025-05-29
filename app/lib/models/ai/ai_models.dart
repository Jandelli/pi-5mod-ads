import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';

part 'ai_models.mapper.dart';

@MappableClass()
class AISummaryRequest with AISummaryRequestMappable, EquatableMixin {
  final String timeframe;
  final List<String> events;
  final List<String> notes;
  final List<String> upcomingTasks;
  final DateTime fromDate;
  final DateTime toDate;

  const AISummaryRequest({
    required this.timeframe,
    required this.events,
    required this.notes,
    required this.upcomingTasks,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props =>
      [timeframe, events, notes, upcomingTasks, fromDate, toDate];
}

@MappableClass()
class AISummaryResponse with AISummaryResponseMappable, EquatableMixin {
  final String summary;
  final List<String> keyHighlights;
  final List<String> upcomingPriorities;
  final String motivation;
  final DateTime generatedAt;

  const AISummaryResponse({
    required this.summary,
    required this.keyHighlights,
    required this.upcomingPriorities,
    required this.motivation,
    required this.generatedAt,
  });

  @override
  List<Object?> get props =>
      [summary, keyHighlights, upcomingPriorities, motivation, generatedAt];
}

@MappableClass()
class OpenAIRequest with OpenAIRequestMappable {
  final String model;
  final List<OpenAIMessage> messages;
  final double temperature;
  final int maxTokens;

  const OpenAIRequest({
    this.model = 'gpt-3.5-turbo',
    required this.messages,
    this.temperature = 0.7,
    this.maxTokens = 1000,
  });
}

@MappableClass()
class OpenAIMessage with OpenAIMessageMappable {
  final String role;
  final String content;

  const OpenAIMessage({
    required this.role,
    required this.content,
  });
}

@MappableClass()
class OpenAIResponse with OpenAIResponseMappable {
  final List<OpenAIChoice> choices;

  const OpenAIResponse({
    required this.choices,
  });
}

@MappableClass()
class OpenAIChoice with OpenAIChoiceMappable {
  final OpenAIMessage message;

  const OpenAIChoice({
    required this.message,
  });
}

enum AISummaryTimeframe {
  week,
  month,
  custom,
}

extension AISummaryTimeframeExtension on AISummaryTimeframe {
  String get displayName {
    switch (this) {
      case AISummaryTimeframe.week:
        return 'Esta Semana';
      case AISummaryTimeframe.month:
        return 'Este Mês';
      case AISummaryTimeframe.custom:
        return 'Período Personalizado';
    }
  }

  String get promptName {
    switch (this) {
      case AISummaryTimeframe.week:
        return 'week';
      case AISummaryTimeframe.month:
        return 'month';
      case AISummaryTimeframe.custom:
        return 'period';
    }
  }
}
