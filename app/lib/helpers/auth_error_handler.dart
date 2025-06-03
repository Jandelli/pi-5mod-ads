import 'package:flutter/material.dart';

/// Comprehensive authentication error handling utility
/// Provides user-friendly error messages and handles various authentication scenarios
class AuthErrorHandler {
  /// Map of error types to user-friendly messages
  static const Map<String, String> _errorMessages = {
    // Login errors
    'invalid_credentials': 'Usuário ou senha incorretos',
    'account_locked':
        'Conta temporariamente bloqueada devido a muitas tentativas de login incorretas. Tente novamente em alguns minutos.',
    'account_disabled':
        'Esta conta foi desativada. Entre em contato com o suporte.',
    'account_not_verified':
        'Por favor, verifique seu email antes de fazer login.',
    'session_expired': 'Sua sessão expirou. Por favor, faça login novamente.',
    'invalid_session': 'Sessão inválida. Por favor, faça login novamente.',

    // Registration errors
    'username_taken': 'Este nome de usuário já está em uso. Escolha outro.',
    'email_taken':
        'Este email já está cadastrado. Tente fazer login ou use outro email.',
    'user_already_exists': 'Já existe uma conta com este usuário.',
    'invalid_email_format': 'Por favor, digite um endereço de email válido.',
    'invalid_username_format':
        'Nome de usuário deve ter entre 3-20 caracteres e conter apenas letras, números e sublinhados.',
    'weak_password':
        'A senha deve ter pelo menos 8 caracteres, incluindo maiúscula, minúscula e número.',
    'password_too_short': 'A senha deve ter pelo menos 8 caracteres.',
    'passwords_dont_match': 'As senhas não coincidem.',

    // Network/Server errors
    'network_error':
        'Erro de conexão. Verifique sua internet e tente novamente.',
    'server_error': 'Erro no servidor. Tente novamente em alguns instantes.',
    'timeout_error':
        'Tempo limite esgotado. Verifique sua conexão e tente novamente.',
    'service_unavailable':
        'Serviço temporariamente indisponível. Tente novamente mais tarde.',

    // Database errors
    'database_error': 'Erro interno. Tente novamente em alguns instantes.',
    'connection_failed': 'Falha na conexão com o banco de dados.',

    // Validation errors
    'required_field': 'Este campo é obrigatório.',
    'invalid_input': 'Entrada inválida. Verifique os dados inseridos.',
    'field_too_long': 'Este campo excede o limite de caracteres permitido.',

    // Permission errors
    'insufficient_permissions':
        'Você não tem permissão para realizar esta ação.',
    'access_denied': 'Acesso negado.',

    // Generic errors
    'unknown_error': 'Ocorreu um erro inesperado. Tente novamente.',
    'operation_failed': 'Operação falhou. Tente novamente.',
  };

  /// Convert raw error to user-friendly message
  static String getErrorMessage(String error) {
    // Clean and normalize the error string
    final cleanError = error.toLowerCase().trim();

    // Direct mapping for known errors
    if (_errorMessages.containsKey(cleanError)) {
      return _errorMessages[cleanError]!;
    }

    // Pattern matching for various error formats
    if (cleanError.contains('invalid credentials') ||
        cleanError.contains('wrong password') ||
        cleanError.contains('incorrect password')) {
      return _errorMessages['invalid_credentials']!;
    }

    if (cleanError.contains('account is locked') ||
        cleanError.contains('account locked') ||
        cleanError.contains('too many attempts')) {
      return _errorMessages['account_locked']!;
    }

    if (cleanError.contains('user already exists') ||
        cleanError.contains('username') && cleanError.contains('exists') ||
        cleanError.contains('email') && cleanError.contains('exists')) {
      if (cleanError.contains('username')) {
        return _errorMessages['username_taken']!;
      } else if (cleanError.contains('email')) {
        return _errorMessages['email_taken']!;
      }
      return _errorMessages['user_already_exists']!;
    }

    if (cleanError.contains('invalid email') ||
        cleanError.contains('email format') ||
        cleanError.contains('malformed email')) {
      return _errorMessages['invalid_email_format']!;
    }

    if (cleanError.contains('password') &&
            cleanError.contains('requirements') ||
        cleanError.contains('weak password') ||
        cleanError.contains('password too weak')) {
      return _errorMessages['weak_password']!;
    }

    if (cleanError.contains('network') ||
        cleanError.contains('connection') ||
        cleanError.contains('internet')) {
      return _errorMessages['network_error']!;
    }

    if (cleanError.contains('timeout') || cleanError.contains('time out')) {
      return _errorMessages['timeout_error']!;
    }

    if (cleanError.contains('server') ||
        cleanError.contains('internal error') ||
        cleanError.contains('500')) {
      return _errorMessages['server_error']!;
    }

    if (cleanError.contains('database') || cleanError.contains('db error')) {
      return _errorMessages['database_error']!;
    }

    if (cleanError.contains('session expired') ||
        cleanError.contains('token expired')) {
      return _errorMessages['session_expired']!;
    }

    if (cleanError.contains('invalid session') ||
        cleanError.contains('invalid token')) {
      return _errorMessages['invalid_session']!;
    }

    if (cleanError.contains('permission') ||
        cleanError.contains('unauthorized')) {
      return _errorMessages['insufficient_permissions']!;
    }

    if (cleanError.contains('service unavailable') ||
        cleanError.contains('503')) {
      return _errorMessages['service_unavailable']!;
    }

    // If no pattern matches, return the generic error message
    return _errorMessages['unknown_error']!;
  }

  /// Get error severity for styling purposes
  static ErrorSeverity getErrorSeverity(String error) {
    final cleanError = error.toLowerCase().trim();

    if (cleanError.contains('locked') ||
        cleanError.contains('disabled') ||
        cleanError.contains('access denied')) {
      return ErrorSeverity.critical;
    }

    if (cleanError.contains('invalid credentials') ||
        cleanError.contains('already exists') ||
        cleanError.contains('password') ||
        cleanError.contains('validation')) {
      return ErrorSeverity.warning;
    }

    if (cleanError.contains('network') ||
        cleanError.contains('server') ||
        cleanError.contains('timeout')) {
      return ErrorSeverity.error;
    }

    return ErrorSeverity.info;
  }

  /// Show error snackbar with appropriate styling
  static void showErrorSnackbar(
    BuildContext context,
    String error, {
    Duration duration = const Duration(seconds: 4),
  }) {
    final message = getErrorMessage(error);
    final severity = getErrorSeverity(error);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getIconForSeverity(severity),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _getColorForSeverity(context, severity),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static IconData _getIconForSeverity(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.critical:
        return Icons.error;
      case ErrorSeverity.error:
        return Icons.warning;
      case ErrorSeverity.warning:
        return Icons.info;
      case ErrorSeverity.info:
        return Icons.info_outline;
    }
  }

  static Color _getColorForSeverity(
      BuildContext context, ErrorSeverity severity) {
    final theme = Theme.of(context);
    switch (severity) {
      case ErrorSeverity.critical:
        return Colors.red.shade700;
      case ErrorSeverity.error:
        return theme.colorScheme.error;
      case ErrorSeverity.warning:
        return Colors.orange.shade600;
      case ErrorSeverity.info:
        return theme.colorScheme.primary;
    }
  }
}

enum ErrorSeverity {
  critical,
  error,
  warning,
  info,
}
