import '../repositories/match_repository.dart';

class LikeJob {
  final MatchRepository repository;

  LikeJob(this.repository);

  Future<void> call(String jobId) {
    return repository.likeJob(jobId);
  }
}
