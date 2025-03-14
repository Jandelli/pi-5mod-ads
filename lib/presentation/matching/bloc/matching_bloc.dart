import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/usecases/get_jobs_usecase.dart';
import '../../../domain/usecases/like_job_usecase.dart';
import '../../../domain/usecases/dislike_job_usecase.dart';
import '../../../core/error/failures.dart';

// Events
abstract class MatchingEvent extends Equatable {
  const MatchingEvent();

  @override
  List<Object?> get props => [];
}

class LoadJobsEvent extends MatchingEvent {}

class LikeJobEvent extends MatchingEvent {
  final Job job;

  const LikeJobEvent(this.job);

  @override
  List<Object> get props => [job];
}

class DislikeJobEvent extends MatchingEvent {
  final Job job;

  const DislikeJobEvent(this.job);

  @override
  List<Object> get props => [job];
}

// States
abstract class MatchingState extends Equatable {
  const MatchingState();

  @override
  List<Object?> get props => [];
}

class MatchingInitial extends MatchingState {}

class MatchingLoading extends MatchingState {}

class JobsLoaded extends MatchingState {
  final List<Job> jobs;
  final List<Job> matchedJobs;

  const JobsLoaded({required this.jobs, this.matchedJobs = const []});

  @override
  List<Object> get props => [jobs, matchedJobs];
}

class JobMatchCreated extends MatchingState {
  final Job job;

  const JobMatchCreated(this.job);

  @override
  List<Object> get props => [job];
}

class MatchingError extends MatchingState {
  final String message;

  const MatchingError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC Implementation
class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  final GetJobsUsecase getJobs;
  final LikeJobUsecase likeJob;
  final DislikeJobUsecase dislikeJob;

  // Keep track of matched jobs
  final List<Job> _matchedJobs = [];

  MatchingBloc({
    required this.getJobs,
    required this.likeJob,
    required this.dislikeJob,
  }) : super(MatchingInitial()) {
    on<LoadJobsEvent>(_onLoadJobs);
    on<LikeJobEvent>(_onLikeJob);
    on<DislikeJobEvent>(_onDislikeJob);
  }

  Future<void> _onLoadJobs(
    LoadJobsEvent event,
    Emitter<MatchingState> emit,
  ) async {
    emit(MatchingLoading());
    try {
      final result = await getJobs(UserId().id);
      emit(
        result.fold(
          (failure) => MatchingError(_mapFailureToMessage(failure)),
          (jobs) => JobsLoaded(jobs: jobs, matchedJobs: _matchedJobs),
        ),
      );
    } catch (e) {
      emit(MatchingError(e.toString()));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    // You can customize error messages based on different failure types
    return failure.toString();
  }

  Future<void> _onLikeJob(
    LikeJobEvent event,
    Emitter<MatchingState> emit,
  ) async {
    try {
      final isMatch = await likeJob(
        event.job,
        UserId().id,
      ); // Added UserId() as the second argument
      if (isMatch) {
        _matchedJobs.add(event.job);
        emit(JobMatchCreated(event.job));
        // After showing the match, we need to emit the loaded state again to update the UI
        emit(
          JobsLoaded(
            jobs: (state as JobsLoaded).jobs,
            matchedJobs: _matchedJobs,
          ),
        );
      }
    } catch (e) {
      emit(MatchingError(e.toString()));
      // Return to previous state
      if (state is JobsLoaded) {
        emit(state);
      } else {
        add(LoadJobsEvent());
      }
    }
  }

  Future<void> _onDislikeJob(
    DislikeJobEvent event,
    Emitter<MatchingState> emit,
  ) async {
    try {
      await dislikeJob(
        event.job,
        UserId().id,
      ); // Added UserId() as the second argument
      // No need to emit a new state, the card will already be gone
    } catch (e) {
      emit(MatchingError(e.toString()));
      // Return to previous state
      if (state is JobsLoaded) {
        emit(state);
      } else {
        add(LoadJobsEvent());
      }
    }
  }
}

// Add these classes at the end of the file
class NoParams {}

class UserId {
  // This is a placeholder - replace with actual user ID implementation
  String id = 'current_user_id';
}
