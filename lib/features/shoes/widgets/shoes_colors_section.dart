import 'package:flutter/material.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_spacing.dart';

/// Detail card with the shoe's primary color (ringed) and extra colors.
class ShoesColorsSection extends StatelessWidget {
  final ShoesModel shoes;

  const ShoesColorsSection({super.key, required this.shoes});

  List<Color> get _allColors => [
        shoes.colorPrimary,
        ...?shoes.colorExtra?.map(Color.new),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.shoes_details_screen_field_color.toUpperCase(),
                style: theme.textTheme.labelSmall,
              ),
            ),
            Flexible(
              flex: 3,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final (index, color) in _allColors.indexed)
                    Tooltip(
                      message: index == 0
                          ? l10n.shoes_details_screen_field_color_primary
                          : '${l10n.extra_colors} $index',
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: index == 0
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.outline,
                            width: index == 0 ? 2 : 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
