import 'package:flutter/material.dart';

/// Full-screen dimmed overlay with a determinate progress ring and the
/// percentage (PDF generation, JSON import).
class ProgressOverlayWidget extends StatelessWidget {
  /// Progress between 0 and 1.
  final double progress;

  const ProgressOverlayWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.square(
              dimension: 100,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
