import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../models/ai/ai_models.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _apiKeyKey = 'openai_api_key';

  final FlutterSecureStorage _secureStorage;
  final http.Client _httpClient;

  OpenAIService({
    FlutterSecureStorage? secureStorage,
    http.Client? httpClient,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _httpClient = httpClient ?? http.Client();

  /// Stores the OpenAI API key securely
  Future<void> setApiKey(String apiKey) async {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty');
    }

    await _secureStorage.write(key: _apiKeyKey, value: apiKey);
  }

  /// Retrieves the stored API key
  Future<String?> getApiKey() async {
    return await _secureStorage.read(key: _apiKeyKey);
  }

  /// Clears the stored API key
  Future<void> clearApiKey() async {
    await _secureStorage.delete(key: _apiKeyKey);
  }

  /// Checks if API key is configured
  Future<bool> hasApiKey() async {
    final apiKey = await getApiKey();
    return apiKey != null && apiKey.isNotEmpty;
  }

  /// Generates AI summary from user data
  Future<AISummaryResponse> generateSummary(AISummaryRequest request) async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
          'OpenAI API key not configured. Please set your API key first.');
    }

    try {
      final prompt = _buildPrompt(request);

      // Changed: Simplified request payload to match the example
      final requestPayload = {
        'model': 'gpt-4o-mini', // Changed model
        'input': prompt, // Use 'input' instead of 'messages'
        // Temperature and maxTokens are omitted to match the example's request structure
      };

      // Changed: _makeOpenAIRequest now takes a Map and returns a Map
      final openAIJsonOutput = await _makeOpenAIRequest(requestPayload, apiKey);
      // Changed: _parseAIResponse now takes the JSON map directly
      return _parseAIResponse(
          openAIJsonOutput, request.fromDate, request.toDate);
    } catch (e) {
      throw Exception('Failed to generate AI summary: $e');
    }
  }

  /// Builds the prompt for OpenAI based on user data
  String _buildPrompt(AISummaryRequest request) {
    final buffer = StringBuffer();

    buffer.writeln(
        'Create a comprehensive summary for my ${request.timeframe} from ${_formatDate(request.fromDate)} to ${_formatDate(request.toDate)}.');
    buffer.writeln();

    buffer.writeln(
      'The date today is ${_formatDate(DateTime.now())}.',
    );
    buffer.writeln();

    // Add events section
    if (request.events.isNotEmpty) {
      buffer.writeln('EVENTS AND ACTIVITIES:');
      for (final event in request.events) {
        buffer.writeln('- $event');
      }
      buffer.writeln();
    }

    // Add notes section
    if (request.notes.isNotEmpty) {
      buffer.writeln('NOTES AND THOUGHTS:');
      for (final note in request.notes) {
        buffer.writeln('- $note');
      }
      buffer.writeln();
    }

    // Add upcoming tasks section
    if (request.upcomingTasks.isNotEmpty) {
      buffer.writeln('UPCOMING TASKS AND COMMITMENTS:');
      for (final task in request.upcomingTasks) {
        buffer.writeln('- $task');
      }
      buffer.writeln();
    }

    buffer.writeln('Please provide a response in the following JSON format:');
    buffer.writeln('{');
    buffer.writeln(
        '  "summary": "A natural language summary of the period highlighting key activities and accomplishments",');
    buffer.writeln(
        '  "keyHighlights": ["highlight 1", "highlight 2", "highlight 3"],');
    buffer.writeln(
        '  "upcomingPriorities": ["priority 1", "priority 2", "priority 3"],');
    buffer.writeln(
        '  "motivation": "A motivational message based on the activities and progress shown"');
    buffer.writeln('}');
    buffer.writeln();
    buffer.writeln(
        'Respond only with the JSON, no additional text. Use Portuguese (Brazilian) for all content.');

    return buffer.toString();
  }

  /// Makes the actual HTTP request to OpenAI
  // Changed: Method signature and return type
  Future<Map<String, dynamic>> _makeOpenAIRequest(
      Map<String, dynamic> requestPayload, String apiKey) async {
    // Changed: Endpoint path
    final url = Uri.parse('$_baseUrl/responses');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    // Changed: Body uses the requestPayload directly
    final body = jsonEncode(requestPayload);

    try {
      final response = await _httpClient
          .post(
            url,
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Changed: Return the parsed JSON map directly
        return jsonResponse;
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your OpenAI API key.');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (response.statusCode >= 500) {
        throw Exception(
            'OpenAI service is temporarily unavailable. Please try again later.');
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['error']?['message'] ?? 'Unknown error';
        throw Exception('OpenAI API error: $errorMessage');
      }
    } on SocketException {
      throw Exception('Network error. Please check your internet connection.');
    } on HttpException {
      throw Exception('HTTP error occurred while communicating with OpenAI.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Unexpected error: $e');
    }
  }

  /// Parses the OpenAI response and extracts the structured data
  // Changed: Method signature to accept Map<String, dynamic>
  AISummaryResponse _parseAIResponse(Map<String, dynamic> openAIResponseJson,
      DateTime fromDate, DateTime toDate) {
    // Changed: Extract content from the new response structure
    final dynamic outputList = openAIResponseJson['output'];
    if (outputList == null || outputList is! List || outputList.isEmpty) {
      throw Exception(
          'OpenAI response is missing "output" field or it is empty.');
    }
    final dynamic firstOutput = outputList[0];
    if (firstOutput == null ||
        firstOutput is! Map ||
        firstOutput['content'] == null) {
      throw Exception(
          'OpenAI response "output" item is missing "content" field.');
    }
    final dynamic contentList = firstOutput['content'];
    if (contentList == null || contentList is! List || contentList.isEmpty) {
      throw Exception('OpenAI response "content" field is empty.');
    }
    final dynamic firstContentElement = contentList[0];
    if (firstContentElement == null ||
        firstContentElement is! Map ||
        firstContentElement['text'] == null) {
      throw Exception(
          'OpenAI response "content" item is missing "text" field.');
    }
    final String rawAiOutput = firstContentElement['text'] as String;

    String parsableJsonString = rawAiOutput.trim();

    // Attempt to extract JSON object from the string
    // This handles cases where the JSON might be wrapped in text or markdown
    int startIndex = parsableJsonString.indexOf('{');
    int endIndex = parsableJsonString.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      parsableJsonString =
          parsableJsonString.substring(startIndex, endIndex + 1);
    } else {
      // If no '{' or '}' found, or in wrong order, it's unlikely to be JSON.
      // Log this situation. The original rawAiOutput will be used in the fallback if parsing fails.
      print(
          'Could not find valid JSON structure markers ({}) in AI output. Attempting to parse as is.');
      // parsableJsonString remains rawAiOutput.trim()
    }

    try {
      // Try to parse the potentially cleaned JSON string
      final jsonData = jsonDecode(parsableJsonString);

      return AISummaryResponse(
        summary: jsonData['summary']?.toString() ?? 'Resumo não disponível.',
        keyHighlights: (jsonData['keyHighlights'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        upcomingPriorities: (jsonData['upcomingPriorities'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        motivation: jsonData['motivation']?.toString() ??
            'Continue seu excelente trabalho!',
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      // If JSON parsing fails, log details and create a fallback response
      print('Failed to parse AI response JSON. Error: $e');
      print('Attempted to parse: "$parsableJsonString"');
      print('Original AI output from API: "$rawAiOutput"');
      return AISummaryResponse(
        summary: rawAiOutput.length > 500
            ? '${rawAiOutput.substring(0, 500)}...'
            : rawAiOutput, // Show the raw output if parsing fails
        keyHighlights: ['Erro ao processar o resumo da IA.'],
        upcomingPriorities: [
          'Verifique os dados de entrada e tente novamente.'
        ],
        motivation: 'Não foi possível gerar a motivação no momento.',
        generatedAt: DateTime.now(),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Disposes of resources
  void dispose() {
    _httpClient.close();
  }
}
