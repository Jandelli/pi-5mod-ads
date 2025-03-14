// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../domain/entities/job.dart';

class JobSwipeCard extends StatelessWidget {
  final Job job;

  const JobSwipeCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Job Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
            child:
                job.imageUrl != null
                    ? Image.network(
                      job.imageUrl!,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 160,
                            color: ColorConstants.primaryColor.withOpacity(0.2),
                            child: const Icon(
                              Icons.work,
                              size: 60,
                              color: ColorConstants.primaryColor,
                            ),
                          ),
                    )
                    : Container(
                      height: 160,
                      color: ColorConstants.primaryColor.withOpacity(0.2),
                      child: const Icon(
                        Icons.work,
                        size: 60,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
          ),

          // Job Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Title
                Text(
                  job.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8.0),

                // Company
                Text(
                  job.company,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 8.0),

                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      job.location,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),

                // Description
                Text(
                  'Job Description:',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8.0),

                Text(
                  job.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Swipe indicators
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.close, color: Colors.red, size: 18),
                      const SizedBox(width: 4),
                      Text('Swipe Left', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Swipe Right',
                        style: TextStyle(color: Colors.green),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.check, color: Colors.green, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
