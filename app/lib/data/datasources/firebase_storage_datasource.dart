import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageDataSource {
  Future<String> uploadFile(File file, String path);
  Future<void> deleteFile(String path);
  Future<String> getFileUrl(String path);
}

class FirebaseStorageDataSourceImpl implements FirebaseStorageDataSource {
  final FirebaseStorage storage;

  FirebaseStorageDataSourceImpl({required this.storage});

  @override
  Future<void> deleteFile(String path) async {
    await storage.ref(path).delete();
  }

  @override
  Future<String> uploadFile(File file, String path) async {
    final ref = storage.ref(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  @override
  Future<String> getFileUrl(String path) async {
    return storage.ref(path).getDownloadURL();
  }
}
