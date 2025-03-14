import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class StorageRepository {
  Future<Either<Failure, String>> uploadProfileImage(
    File imageFile,
    String userId,
  );
  Future<Either<Failure, String>> getImageUrl(String imagePath);
  Future<Either<Failure, bool>> deleteImage(String imagePath);
}
