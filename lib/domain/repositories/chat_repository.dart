import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, bool>> sendMessage(Message message);
  Future<Either<Failure, List<Message>>> getMessages(String chatId);
  Future<Either<Failure, Chat>> getChatById(String chatId);
  Future<Either<Failure, List<Chat>>> getUserChats(String userId);
}
