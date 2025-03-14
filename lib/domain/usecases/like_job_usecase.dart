import '../entities/job.dart';
import '../repositories/job_repository.dart';

class LikeJobUsecase {
  final JobRepository repository;

  LikeJobUsecase(this.repository);

  /// Returns true if there's a match, false otherwise
  Future<bool> call(Job job, String userId) async {
    await repository.likeJob(userId, job.id);
    // Since the repository method doesn't return a match indicator,
    // we would need to implement additional logic to determine if there's a match
    // For now, returning false as a placeholder
    return false;
  }
}
