import 'package:flow/models/auth/user.dart';
import 'package:flow/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthService authService;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    mockSharedPreferences = MockSharedPreferences();
    authService = AuthService(mockFlutterSecureStorage, mockSharedPreferences);

    // Mock SharedPreferences.setBool
    when(() => mockSharedPreferences.setBool(any(), any()))
        .thenAnswer((_) async => true);
    // Mock SharedPreferences.remove
    when(() => mockSharedPreferences.remove(any()))
        .thenAnswer((_) async => true);
    // Mock FlutterSecureStorage.write
    when(() => mockFlutterSecureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async => {});
    // Mock FlutterSecureStorage.read
    when(() => mockFlutterSecureStorage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
    // Mock FlutterSecureStorage.delete
    when(() => mockFlutterSecureStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async => {});
  });

  group('AuthService Login', () {
    test('successful login with admin credentials', () async {
      final credentials = LoginCredentials(
          username: 'admin', password: 'password', rememberMe: false);
      final user = await authService.login(credentials);

      expect(user, isNotNull);
      expect(user?.username, 'admin');
      expect(user?.roles, contains('admin'));
      expect(authService.isAuthenticated, isTrue);
      expect(authService.currentUser, user);
    });

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

    test('failed login with invalid credentials', () async {
      final credentials = LoginCredentials(
          username: 'invalid', password: 'user', rememberMe: false);

      expect(() async => await authService.login(credentials), throwsException);
      expect(authService.isAuthenticated, isFalse);
      expect(authService.currentUser, isNull);
    });

    test('session is stored after successful login', () async {
      final credentials = LoginCredentials(
          username: 'admin', password: 'password', rememberMe: false);
      await authService.login(credentials);

      verify(() => mockFlutterSecureStorage.write(
          key: 'auth_session', value: any(named: 'value'))).called(1);
      verify(() => mockSharedPreferences.setBool('auth_remember_me', false))
          .called(1);
    });

    test('rememberMe functionality stores session accordingly', () async {
      // Test with rememberMe = true
      final credentialsTrue = LoginCredentials(
          username: 'admin', password: 'password', rememberMe: true);
      await authService.login(credentialsTrue);

      expect(authService.currentSession?.rememberMe, isTrue);
      expect(authService.currentSession?.expiresAt, isNotNull);
      // Expect expiration to be around 30 days from now
      expect(
          authService.currentSession!.expiresAt
              .difference(DateTime.now())
              .inDays,
          closeTo(30, 1));
      verify(() => mockSharedPreferences.setBool('auth_remember_me', true))
          .called(1);

      // Clear mocks for next verification
      clearInteractions(mockFlutterSecureStorage);
      clearInteractions(mockSharedPreferences);
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockFlutterSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async => {});

      // Test with rememberMe = false
      final credentialsFalse = LoginCredentials(
          username: 'user', password: 'password', rememberMe: false);
      await authService.login(credentialsFalse);

      expect(authService.currentSession?.rememberMe, isFalse);
      expect(authService.currentSession?.expiresAt, isNotNull);
      // Expect expiration to be around 1 day from now
      expect(
          authService.currentSession!.expiresAt
              .difference(DateTime.now())
              .inHours,
          closeTo(24, 1));
      verify(() => mockSharedPreferences.setBool('auth_remember_me', false))
          .called(1);
    });
  });
}
