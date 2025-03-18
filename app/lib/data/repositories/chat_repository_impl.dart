// chat_repository_impl.dart
import '../../core/network/network_info.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/firestore_chat_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart' as failures;
import '../../domain/entities/message.dart';
import '../../domain/entities/chat.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirestoreChatDataSource firestoreChatDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.firestoreChatDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<failures.Failure, bool>> sendMessage(Message message) async {
    if (await networkInfo.isConnected()) {
      try {
        final result = await firestoreChatDataSource.sendMessage(
          message.senderId,
          message.receiverId,
          message.content,
        );
        return Right(result);
      } catch (e) {
        return Left(failures.ServerFailure(message: e.toString()));
      }
    } else {
      return Left(failures.NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<failures.Failure, List<Message>>> getMessages(
    String chatId,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final streamData = firestoreChatDataSource.getMessages(chatId);
        final data = await streamData.first;
        final messages = data.map((map) => Message.fromJson(map)).toList();
        return Right(messages);
      } catch (e) {
        return Left(failures.ServerFailure(message: e.toString()));
      }
    } else {
      return Left(failures.NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<failures.Failure, Chat>> getChatById(String chatId) async {
    if (await networkInfo.isConnected()) {
      try {
        final data = await firestoreChatDataSource.getChatById(chatId);
        final chat = Chat.fromMap(data);
        return Right(chat);
      } catch (e) {
        return Left(failures.ServerFailure(message: e.toString()));
      }
    } else {
      return Left(failures.NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<failures.Failure, List<Chat>>> getUserChats(
    String userId,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final data = await firestoreChatDataSource.getUserChats(userId);
        final chats = data.map((map) => Chat.fromMap(map)).toList();
        return Right(chats);
      } catch (e) {
        return Left(failures.ServerFailure(message: e.toString()));
      }
    } else {
      return Left(failures.NetworkFailure(message: 'No internet connection'));
    }
  }
}
