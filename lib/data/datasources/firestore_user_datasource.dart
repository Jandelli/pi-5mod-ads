import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreUserDataSource {
  Future<void> createUserProfile(String userId, Map<String, dynamic> userData);
  Future<Map<String, dynamic>> getUserProfile(String userId);
  Future<void> updateUserProfile(String userId, Map<String, dynamic> userData);
}

class FirestoreUserDataSourceImpl implements FirestoreUserDataSource {
  final FirebaseFirestore firestore;

  FirestoreUserDataSourceImpl({required this.firestore});

  @override
  Future<void> createUserProfile(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    await firestore.collection('users').doc(userId).set(userData);
  }

  @override
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    return doc.data() as Map<String, dynamic>;
  }

  @override
  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    await firestore.collection('users').doc(userId).update(userData);
  }
}
