import 'package:flow/models/auth/user.dart';
import 'package:flow/services/auth_service.dart';
import 'package:flow/services/auth_database_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

// Cria classes mock para os serviços e dependências.
class MockAuthDatabaseService extends Mock implements AuthDatabaseService {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthService authService;
  late MockAuthDatabaseService mockAuthDatabaseService;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late MockSharedPreferences mockSharedPreferences;

  // Configuração executada antes de cada teste.
  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    mockSharedPreferences = MockSharedPreferences();
    mockAuthDatabaseService = MockAuthDatabaseService();

    // Inicializa AuthService com os mocks.
    authService = AuthService(mockAuthDatabaseService, mockSharedPreferences);

    // Configura o comportamento padrão para SharedPreferences.setBool.
    when(() => mockSharedPreferences.setBool(any(), any()))
        .thenAnswer((_) async => true);
    // Configura o comportamento padrão para SharedPreferences.remove.
    when(() => mockSharedPreferences.remove(any()))
        .thenAnswer((_) async => true);
    // Configura o comportamento padrão para FlutterSecureStorage.write.
    when(() => mockFlutterSecureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async => {});
    // Configura o comportamento padrão para FlutterSecureStorage.read (retorna null por padrão).
    when(() => mockFlutterSecureStorage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
    // Configura o comportamento padrão para FlutterSecureStorage.delete.
    when(() => mockFlutterSecureStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async => {});
  });

  // Grupo de testes para a funcionalidade de login do AuthService.
  group('AuthService Login', () {
    // Testa o login bem-sucedido com credenciais de administrador.
    test('successful login with admin credentials', () async {
      final credentials = LoginCredentials(
          username: 'admin', password: 'password', rememberMe: false);

      // Configura o comportamento do mock para AuthDatabaseService.
      when(() => mockAuthDatabaseService.authenticate(credentials))
          .thenAnswer((_) async => AuthSession(
                token: 'test-token',
                user: AuthUser(
                  id: '1',
                  username: 'admin',
                  email: 'admin@example.com',
                  roles: ['admin'],
                  createdAt: DateTime(2025),
                  lastLoginAt: DateTime(2025),
                ),
                expiresAt: DateTime.now().add(const Duration(hours: 24)),
                rememberMe: false,
              ));

      // Realiza o login.
      final user = await authService.login(credentials);

      // Verifica se o usuário não é nulo e se os dados estão corretos.
      expect(user, isNotNull);
      expect(user?.username, 'admin');
      expect(user?.roles, contains('admin'));
      expect(authService.isAuthenticated, isTrue);
      expect(authService.currentUser, user);
    });

    // Testa o login bem-sucedido com credenciais de usuário comum.
    test('successful login with user credentials', () async {
      final credentials = LoginCredentials(
          username: 'user', password: 'password', rememberMe: false);
      final user = await authService.login(credentials);

      expect(user, isNotNull);
      expect(user?.username, 'user');
      expect(user?.roles, contains('user'));
      expect(authService.isAuthenticated, isTrue);
      expect(authService.currentUser, user);
    });

    // Testa a falha no login com credenciais inválidas.
    test('failed login with invalid credentials', () async {
      final credentials = LoginCredentials(
          username: 'invalid', password: 'user', rememberMe: false);

      // Verifica se uma exceção é lançada ao tentar fazer login com credenciais inválidas.
      expect(() async => await authService.login(credentials), throwsException);
      // Verifica se o estado de autenticação e o usuário atual permanecem como não autenticados.
      expect(authService.isAuthenticated, isFalse);
      expect(authService.currentUser, isNull);
    });

    // Testa se a sessão é armazenada após um login bem-sucedido.
    test('session is stored after successful login', () async {
      final credentials = LoginCredentials(
          username: 'admin', password: 'password', rememberMe: false);
      await authService.login(credentials);

      // Verifica se FlutterSecureStorage.write foi chamado para armazenar a sessão.
      verify(() => mockFlutterSecureStorage.write(
          key: 'auth_session', value: any(named: 'value'))).called(1);
      // Verifica se SharedPreferences.setBool foi chamado para 'auth_remember_me'.
      verify(() => mockSharedPreferences.setBool('auth_remember_me', false))
          .called(1);
    });

    // Testa se a funcionalidade 'rememberMe' armazena a sessão de acordo.
    test('rememberMe functionality stores session accordingly', () async {
      // Testa com rememberMe = true.
      final credentialsTrue = LoginCredentials(
          username: 'admin', password: 'password', rememberMe: true);
      await authService.login(credentialsTrue);

      // Verifica se a sessão atual reflete rememberMe = true e se a data de expiração está correta.
      expect(authService.currentSession?.rememberMe, isTrue);
      expect(authService.currentSession?.expiresAt, isNotNull);
      // Espera que a expiração seja aproximadamente 30 dias a partir de agora.
      expect(
          authService.currentSession!.expiresAt
              .difference(DateTime.now())
              .inDays,
          closeTo(30, 1)); // closeTo permite uma pequena margem de erro.
      // Verifica se SharedPreferences.setBool foi chamado corretamente.
      verify(() => mockSharedPreferences.setBool('auth_remember_me', true))
          .called(1);

      // Limpa as interações dos mocks para a próxima verificação.
      clearInteractions(mockFlutterSecureStorage);
      clearInteractions(mockSharedPreferences);
      // Reconfigura o comportamento dos mocks, pois clearInteractions também remove os stubs.
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockFlutterSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async => {});

      // Testa com rememberMe = false.
      final credentialsFalse = LoginCredentials(
          username: 'user', password: 'password', rememberMe: false);
      await authService.login(credentialsFalse);

      // Verifica se a sessão atual reflete rememberMe = false e se a data de expiração está correta.
      expect(authService.currentSession?.rememberMe, isFalse);
      expect(authService.currentSession?.expiresAt, isNotNull);
      // Espera que a expiração seja aproximadamente 24 horas (1 dia) a partir de agora.
      expect(
          authService.currentSession!.expiresAt
              .difference(DateTime.now())
              .inHours,
          closeTo(24, 1));
      // Verifica se SharedPreferences.setBool foi chamado corretamente.
      verify(() => mockSharedPreferences.setBool('auth_remember_me', false))
          .called(1);
    });
  });
}
