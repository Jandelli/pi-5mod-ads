import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/datasources/local_storage_datasource.dart';
import '../../core/network/network_info.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefs);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<LocalStorageDataSource>(
    () => LocalStorageDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuthDataSource: sl(),
      localStorageDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuthDataSource: sl(),
      localStorageDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(
    () =>
        (String email, String password) =>
            sl<AuthRepository>().signInWithEmail(email, password),
  );

  sl.registerLazySingleton(() => () => sl<AuthRepository>().signInWithGoogle());

  sl.registerLazySingleton(
    () =>
        (String email, String password, String name) =>
            sl<AuthRepository>().signUpWithDetails(email, password, name),
  );

  sl.registerLazySingleton(() => () => sl<AuthRepository>().signOut());
}
