import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/swipe_card.dart';
import '../../../domain/entities/job.dart';
import '../bloc/matching_bloc.dart';
import '../widgets/job_swipe_card.dart';
import '../widgets/match_notification.dart';
import '../widgets/empty_state.dart';

class JobMatchingScreen extends StatefulWidget {
  const JobMatchingScreen({super.key});

  @override
  State<JobMatchingScreen> createState() => _JobMatchingScreenState();
}

class _JobMatchingScreenState extends State<JobMatchingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load jobs when the screen is first displayed
    context.read<MatchingBloc>().add(LoadJobsEvent());

    // Listen for match events
    context.read<MatchingBloc>().stream.listen((state) {
      if (state is JobMatchCreated) {
        _showMatchDialog(state.job);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showMatchDialog(Job job) {
    showDialog(
      context: context,
      builder:
          (context) => MatchNotification(
            job: job,
            onDismiss: () => Navigator.pop(context),
            onViewMatch: () {
              Navigator.pop(context);
              _tabController.animateTo(1); // Switch to the matches tab
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AplicAI'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.work), text: 'Jobs'),
            Tab(icon: Icon(Icons.favorite), text: 'Matches'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildJobsTab(), _buildMatchesTab()],
      ),
    );
  }

  Widget _buildJobsTab() {
    return BlocBuilder<MatchingBloc, MatchingState>(
      builder: (context, state) {
        if (state is MatchingInitial || state is MatchingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is JobsLoaded) {
          if (state.jobs.isEmpty) {
            return const EmptyState(
              icon: Icons.work_off,
              title: 'No jobs available',
              subtitle: 'We\'ll notify you when new jobs match your profile',
            );
          }

          return _buildJobCards(state.jobs);
        } else if (state is MatchingError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const Center(child: Text('Something went wrong'));
      },
    );
  }

  Widget _buildJobCards(List<Job> jobs) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SwipeCard(
        cardCount: jobs.length,
        cardBuilder: (context, index) => JobSwipeCard(job: jobs[index]),
        onSwipeRight: (index) {
          context.read<MatchingBloc>().add(LikeJobEvent(jobs[index]));
        },
        onSwipeLeft: (index) {
          context.read<MatchingBloc>().add(DislikeJobEvent(jobs[index]));
        },
        onCardRemoved: (index, direction) {
          if (index == jobs.length - 1) {
            // Last card was removed, maybe show some feedback
          }
        },
      ),
    );
  }

  Widget _buildMatchesTab() {
    return BlocBuilder<MatchingBloc, MatchingState>(
      builder: (context, state) {
        if (state is MatchingInitial || state is MatchingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is JobsLoaded) {
          final matches = state.matchedJobs;

          if (matches.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border,
              title: 'No matches yet',
              subtitle: 'Keep swiping to find your perfect job match',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final job = matches[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(job.title),
                  subtitle: Text(job.company),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to job details
                    // Navigator.pushNamed(context, '/job-detail', arguments: job);
                  },
                ),
              );
            },
          );
        } else if (state is MatchingError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const Center(child: Text('Something went wrong'));
      },
    );
  }
}
