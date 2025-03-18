import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/job.dart';

abstract class JobRepository {
  Future<Either<Failure, List<Job>>> getRecommendedJobs(String userId);
  Future<Either<Failure, bool>> likeJob(String userId, String jobId);
  Future<Either<Failure, bool>> dislikeJob(String userId, String jobId);
  Future<Either<Failure, String>> postJob(Job job);
  Future<Either<Failure, Job>> getJobById(String jobId);
  Future<Either<Failure, List<Job>>> getJobsByEmployer(String employerId);
}
