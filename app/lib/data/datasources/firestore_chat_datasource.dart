import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreChatDataSource {
  Future<bool> sendMessage(String senderId, String receiverId, String message);
  Stream<List<Map<String, dynamic>>> getMessages(String chatId);
  Future<Map<String, dynamic>> getChatById(String chatId);
  Future<List<Map<String, dynamic>>> getUserChats(String userId);
}

class FirestoreChatDataSourceImpl implements FirestoreChatDataSource {
  final FirebaseFirestore firestore;

  FirestoreChatDataSourceImpl({required this.firestore});

  @override
  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              }).toList(),
        );
  }

  @override
  Future<bool> sendMessage(
    String senderId,
    String receiverId,
    String message,
  ) async {
    final users = [senderId, receiverId];
    users.sort();
    final chatId = users.join('_');
    try {
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'senderId': senderId,
            'message': message,
            'timestamp': FieldValue.serverTimestamp(),
            'isRead': false,
          });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getChatById(String chatId) async {
    final doc = await firestore.collection('chats').doc(chatId).get();
    if (doc.exists) {
      final data = doc.data()!;
      data['id'] = doc.id;
      return data;
    }
    throw Exception('Chat not found');
  }

  @override
  Future<List<Map<String, dynamic>>> getUserChats(String userId) async {
    final snapshot =
        await firestore
            .collection('chats')
            .where('participants', arrayContains: userId)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }
}
