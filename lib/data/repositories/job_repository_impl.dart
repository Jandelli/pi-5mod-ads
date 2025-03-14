// job_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasources/firestore_job_datasource.dart';
import '../../core/network/network_info.dart';

class JobRepositoryImpl implements JobRepository {
  final FirestoreJobDataSource firestoreJobDataSource;
  final NetworkInfo networkInfo;

  JobRepositoryImpl({
    required this.firestoreJobDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Job>>> getRecommendedJobs(String userId) async {
    if (await networkInfo.isConnected()) {
      try {
        final jobsData = await firestoreJobDataSource.getRecommendedJobs(
          userId,
        );
        final jobs = jobsData.map((data) => Job.fromMap(data)).toList();
        return Right(jobs);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, bool>> likeJob(String userId, String jobId) async {
    if (await networkInfo.isConnected()) {
      try {
        await firestoreJobDataSource.likeJob(userId, jobId);
        return Right(true);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, bool>> dislikeJob(String userId, String jobId) async {
    if (await networkInfo.isConnected()) {
      try {
        await firestoreJobDataSource.dislikeJob(userId, jobId);
        return Right(true);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String>> postJob(Job job) async {
    if (await networkInfo.isConnected()) {
      try {
        await firestoreJobDataSource.postJob(job.toMap());
        return Right("Job posted successfully");
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, Job>> getJobById(String jobId) async {
    if (await networkInfo.isConnected()) {
      try {
        final jobData = await firestoreJobDataSource.getJobById(jobId);
        final job = Job.fromMap(jobData);
        return Right(job);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getJobsByEmployer(
    String employerId,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final jobsData = await firestoreJobDataSource.getJobsByEmployer(
          employerId,
        );
        final jobs = jobsData.map((data) => Job.fromMap(data)).toList();
        return Right(jobs);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }
}
