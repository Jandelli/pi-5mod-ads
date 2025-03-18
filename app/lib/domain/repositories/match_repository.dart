import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class MatchRepository {
  Future<Either<Failure, List<Match>>> getUserMatches(String userId);
  Future<Either<Failure, bool>> createMatch(Match match);
  Future<Either<Failure, bool>> updateMatchStatus(
    String matchId,
    String status,
  );
  Future<Either<Failure, bool>> likeJob(String jobId);
}
