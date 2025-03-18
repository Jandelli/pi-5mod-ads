import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              // ignore: deprecated_member_use
              color: ColorConstants.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (action != null) const SizedBox(height: 24),
            if (action != null) action!,
          ],
        ),
      ),
    );
  }
}
