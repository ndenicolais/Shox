import 'package:flutter/material.dart';
import 'package:shox/theme/app_spacing.dart';

/// White card with an uppercase label and a bold value (detail, profile,
/// statistics).
class InfoTileWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const InfoTileWidget({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                ],
                Expanded(
                  child: Text(
                    label.toUpperCase(),
                    style: theme.textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              value,
              style: theme.textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
