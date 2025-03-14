import '../../core/network/network_info.dart';
import '../../domain/repositories/storage_repository.dart';
import '../datasources/firebase_storage_datasource.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';

class StorageRepositoryImpl implements StorageRepository {
  final FirebaseStorageDataSource firebaseStorageDataSource;
  final NetworkInfo networkInfo;

  StorageRepositoryImpl({
    required this.firebaseStorageDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> uploadProfileImage(
    File imageFile,
    String userId,
  ) async {
    // ...check connectivity...
    // ...try uploading file using firebaseStorageDataSource...
    return Future.value(Left(ServerFailure(message: '')));
  }

  @override
  Future<Either<Failure, String>> getImageUrl(String imagePath) async {
    // ...check connectivity...
    // ...fetch URL via firebaseStorageDataSource...
    return Future.value(Left(ServerFailure(message: '')));
  }

  @override
  Future<Either<Failure, bool>> deleteImage(String imagePath) async {
    // ...check connectivity...
    // ...delete file via firebaseStorageDataSource...
    return Future.value(Left(ServerFailure(message: '')));
  }
}
