import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreJobDataSource {
  Future<void> postJob(Map<String, dynamic> jobData);
  Future<List<Map<String, dynamic>>> getRecommendedJobs(String userId);
  Future<void> likeJob(String userId, String jobId);
  Future<void> dislikeJob(String userId, String jobId);
  Future<Map<String, dynamic>> getJobById(String jobId);
  Future<List<Map<String, dynamic>>> getJobsByEmployer(String employerId);
}

class FirestoreJobDataSourceImpl implements FirestoreJobDataSource {
  final FirebaseFirestore firestore;

  FirestoreJobDataSourceImpl({required this.firestore});

  @override
  Future<List<Map<String, dynamic>>> getRecommendedJobs(String userId) async {
    final snapshot = await firestore.collection('jobs').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> likeJob(String userId, String jobId) async {
    await firestore.collection('likes').add({
      'userId': userId,
      'jobId': jobId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> dislikeJob(String userId, String jobId) async {
    final query =
        await firestore
            .collection('likes')
            .where('userId', isEqualTo: userId)
            .where('jobId', isEqualTo: jobId)
            .get();

    for (final doc in query.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> postJob(Map<String, dynamic> jobData) async {
    await firestore.collection('jobs').add(jobData);
  }

  @override
  Future<Map<String, dynamic>> getJobById(String jobId) async {
    final doc = await firestore.collection('jobs').doc(jobId).get();
    return doc.data()!;
  }

  @override
  Future<List<Map<String, dynamic>>> getJobsByEmployer(
    String employerId,
  ) async {
    final snapshot =
        await firestore
            .collection('jobs')
            .where('employerId', isEqualTo: employerId)
            .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
