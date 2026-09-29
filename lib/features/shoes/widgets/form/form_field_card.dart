import 'package:flutter/material.dart';
import 'package:shox/theme/app_spacing.dart';

/// White card grouping one form field under an uppercase label.
///
/// Text fields inside use the page background as fill, so they stand out
/// from the white card.
class FormFieldCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const FormFieldCard({
    super.key,
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: AppSpacing.xs),
                Text(label.toUpperCase(), style: theme.textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Theme(
              data: theme.copyWith(
                inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                  fillColor: theme.colorScheme.surface,
                ),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// Round option (size, season) filled with `primary` when selected.
class OptionCircle extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final String? text;
  final IconData? icon;
  final String semanticsLabel;

  const OptionCircle({
    super.key,
    required this.selected,
    required this.onTap,
    required this.semanticsLabel,
    this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color foreground = selected ? colors.onPrimary : colors.onSurface;

    return Semantics(
      button: true,
      selected: selected,
      label: semanticsLabel,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? colors.primary : colors.surface,
            border: Border.all(
              color: selected ? colors.primary : colors.outline,
            ),
          ),
          child: icon != null
              ? Icon(icon, size: 20, color: foreground)
              : Text(
                  text ?? '',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                      ),
                ),
        ),
      ),
    );
  }
}

/// Color swatch with a ring around it when selected.
class ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const ColorDot({
    super.key,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? colors.onSurface : Colors.transparent,
              width: 2,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: colors.outline),
            ),
          ),
        ),
      ),
    );
  }
}
