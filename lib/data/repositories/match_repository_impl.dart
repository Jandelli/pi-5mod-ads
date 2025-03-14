import '../../core/network/network_info.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/firestore_match_datasource.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class MatchRepositoryImpl implements MatchRepository {
  final FirestoreMatchDataSource firestoreMatchDataSource;
  final NetworkInfo networkInfo;

  MatchRepositoryImpl({
    required this.firestoreMatchDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Match>>> getUserMatches(String userId) async {
    // ...implementation here...
    return Right([]);
  }

  @override
  Future<Either<Failure, bool>> createMatch(Match match) async {
    // ...implementation here...
    return Right(true);
  }

  @override
  Future<Either<Failure, bool>> updateMatchStatus(
    String matchId,
    String status,
  ) async {
    // ...implementation here...
    return Right(true);
  }

  @override
  Future<Either<Failure, bool>> likeJob(String jobId) async {
    // ...implementation here...
    return Right(true);
  }
}
