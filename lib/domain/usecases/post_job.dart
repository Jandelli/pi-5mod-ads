import '../entities/job.dart';
import '../repositories/job_repository.dart';

class PostJob {
  final JobRepository repository;

  PostJob(this.repository);

  Future<void> call(Job job) {
    return repository.postJob(job);
  }
}
