import '../entities/job.dart';
import '../repositories/job_repository.dart';

class DislikeJobUsecase {
  final JobRepository repository;

  DislikeJobUsecase(this.repository);

  Future<void> call(Job job, String userId) {
    return repository.dislikeJob(job.id, userId);
  }
}
