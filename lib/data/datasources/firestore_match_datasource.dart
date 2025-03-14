import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreMatchDataSource {
  Future<List<Map<String, dynamic>>> getMatches(String userId);
}

class FirestoreMatchDataSourceImpl implements FirestoreMatchDataSource {
  final FirebaseFirestore firestore;

  FirestoreMatchDataSourceImpl({required this.firestore});

  @override
  Future<List<Map<String, dynamic>>> getMatches(String userId) async {
    final snapshot =
        await firestore
            .collection('matches')
            .where('userId', isEqualTo: userId)
            .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
