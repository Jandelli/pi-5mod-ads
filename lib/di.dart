import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'data/datasources/firebase_auth_datasource.dart';
import 'data/datasources/firestore_chat_datasource.dart';
import 'data/datasources/firestore_job_datasource.dart';
import 'data/datasources/firestore_match_datasource.dart';
import 'data/datasources/firestore_user_datasource.dart';
import 'data/datasources/firebase_storage_datasource.dart';
import 'data/datasources/local_storage_datasource.dart';
import 'data/repositories/auth_repository_impl.dart' as data_impl;
import 'data/repositories/chat_repository_impl.dart';
import 'data/repositories/job_repository_impl.dart';
import 'data/repositories/match_repository_impl.dart';
import 'data/repositories/storage_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/repositories/job_repository.dart';
import 'domain/repositories/match_repository.dart';
import 'domain/repositories/storage_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/sign_in_with_email.dart';
import 'domain/usecases/sign_up.dart';
import 'domain/usecases/get_user_profile.dart';
import 'domain/usecases/update_user_profile.dart';
import 'domain/usecases/get_recommended_jobs.dart';
import 'domain/usecases/like_job.dart';
import 'domain/usecases/post_job.dart';
import 'domain/usecases/send_message.dart';

final sl = GetIt.instance;

Future<void> init() async {
  try {
    //! Features

    // BLoCs will be registered in their respective presentation layers

    // Use cases - use the actual class names from your implementation files
    sl.registerLazySingleton(() => SignInWithEmail(sl()));
    sl.registerLazySingleton(() => SignUp(sl()));
    sl.registerLazySingleton(() => GetUserProfile(sl()));
    sl.registerLazySingleton(() => UpdateUserProfile(sl()));
    sl.registerLazySingleton(() => GetRecommendedJobs(sl()));
    sl.registerLazySingleton(() => LikeJob(sl()));
    sl.registerLazySingleton(() => PostJob(sl()));
    sl.registerLazySingleton(() => SendMessage(sl()));

    //! Repositories
    sl.registerLazySingleton<AuthRepository>(
      () => data_impl.AuthRepositoryImpl(
        firebaseAuthDataSource: sl(),
        localStorageDataSource: sl(),
        networkInfo: sl(),
      ),
    );

    sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        firestoreUserDataSource: sl(),
        localStorageDataSource: sl(),
        networkInfo: sl(),
      ),
    );

    sl.registerLazySingleton<JobRepository>(
      () => JobRepositoryImpl(firestoreJobDataSource: sl(), networkInfo: sl()),
    );

    sl.registerLazySingleton<MatchRepository>(
      () => MatchRepositoryImpl(
        firestoreMatchDataSource: sl(),
        networkInfo: sl(),
      ),
    );

    sl.registerLazySingleton<ChatRepository>(
      () =>
          ChatRepositoryImpl(firestoreChatDataSource: sl(), networkInfo: sl()),
    );

    sl.registerLazySingleton<StorageRepository>(
      () => StorageRepositoryImpl(
        firebaseStorageDataSource: sl(),
        networkInfo: sl(),
      ),
    );

    // DataSources
    sl.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSourceImpl(firebaseAuth: sl()),
    );

    sl.registerLazySingleton<FirestoreUserDataSource>(
      () => FirestoreUserDataSourceImpl(firestore: sl()),
    );

    sl.registerLazySingleton<FirestoreJobDataSource>(
      () => FirestoreJobDataSourceImpl(firestore: sl()),
    );

    sl.registerLazySingleton<FirestoreMatchDataSource>(
      () => FirestoreMatchDataSourceImpl(firestore: sl()),
    );

    sl.registerLazySingleton<FirestoreChatDataSource>(
      () => FirestoreChatDataSourceImpl(firestore: sl()),
    );

    sl.registerLazySingleton<FirebaseStorageDataSource>(
      () => FirebaseStorageDataSourceImpl(storage: sl()),
    );

    sl.registerLazySingleton<LocalStorageDataSource>(
      () => LocalStorageDataSourceImpl(sharedPreferences: sl()),
    );

    //! Core
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

    //! External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => FirebaseAuth.instance);
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
    sl.registerLazySingleton(() => FirebaseStorage.instance);

    // Use a different approach for web platform for connectivity
    if (kIsWeb) {
      sl.registerLazySingleton(
        () => InternetConnectionChecker.createInstance(),
      );
    } else {
      sl.registerLazySingleton(
        () => InternetConnectionChecker.createInstance(),
      );
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error in dependency injection: $e');
      print('Stack trace: $stackTrace');
    }
    rethrow;
  }
}
