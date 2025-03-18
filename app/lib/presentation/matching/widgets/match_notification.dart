// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../domain/entities/job.dart';

class MatchNotification extends StatelessWidget {
  final Job job;
  final VoidCallback onDismiss;
  final VoidCallback onViewMatch;

  const MatchNotification({
    super.key,
    required this.job,
    required this.onDismiss,
    required this.onViewMatch,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Match Title with animation
            TweenAnimationBuilder(
              duration: const Duration(seconds: 1),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(scale: value, child: child),
                );
              },
              child: const Text(
                'It\'s a Match!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Job Image
            CircleAvatar(
              radius: 60,
              backgroundColor: ColorConstants.primaryColor.withOpacity(0.2),
              backgroundImage:
                  job.imageUrl != null ? NetworkImage(job.imageUrl!) : null,
              child:
                  job.imageUrl == null
                      ? const Icon(
                        Icons.work,
                        size: 60,
                        color: ColorConstants.primaryColor,
                      )
                      : null,
            ),

            const SizedBox(height: 16),

            // Job Title
            Text(
              job.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Company Name
            Text(
              job.company,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // View Match Button
            ElevatedButton(
              onPressed: onViewMatch,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('View Match'),
            ),

            const SizedBox(height: 12),

            // Dismiss Button
            TextButton(
              onPressed: onDismiss,
              child: const Text('Continue Browsing'),
            ),
          ],
        ),
      ),
    );
  }
}
