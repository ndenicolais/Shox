import 'package:flutter/material.dart';
import 'package:shox/common/widgets/skeleton_widget.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/features/home/widgets/shoe_card.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_breakpoints.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/theme/app_spacing.dart';

/// Grid geometry for the user's column choice: pure logic, no widgets.
@immutable
class ShoesGridLayout {
  static const double crossSpacing = AppSpacing.s;
  static const double mainSpacing = AppSpacing.m;

  final GridColumns choice;

  const ShoesGridLayout(this.choice);

  int get _baseColumns => switch (choice) {
        GridColumns.gOne => 1,
        GridColumns.gTwo => 2,
        GridColumns.gThree => 3,
      };

  /// Columns actually shown for [maxWidth]: the user's choice, raised on
  /// wide screens (tablets, landscape). A single column always stays single.
  int columnsFor(double maxWidth) => choice == GridColumns.gOne
      ? 1
      : AppBreakpoints.gridColumnsForWidth(maxWidth, minColumns: _baseColumns)
          .clamp(_baseColumns, 4);

  double cellWidth(double maxWidth, int columns) =>
      (maxWidth - crossSpacing * (columns - 1)) / columns;

  /// Square photo plus the caption block of [ShoeCard].
  SliverGridDelegate delegate({
    required int columns,
    required double cellWidth,
    required double captionHeight,
  }) =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: crossSpacing,
        mainAxisSpacing: mainSpacing,
        mainAxisExtent: cellWidth + captionHeight,
      );
}

/// Placeholder grid with the same columns and card shape as the real one.
class ShoesGridSkeleton extends StatelessWidget {
  final ShoesGridLayout layout;

  const ShoesGridSkeleton({super.key, required this.layout});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context)!.a11y_loading,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final int columns = layout.columnsFor(constraints.maxWidth);
          final double cellWidth =
              layout.cellWidth(constraints.maxWidth, columns);
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: AppSpacing.xl),
            gridDelegate: layout.delegate(
              columns: columns,
              cellWidth: cellWidth,
              captionHeight: ShoeCard.captionHeight(context),
            ),
            itemCount: columns * 4,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonWidget(
                  width: cellWidth,
                  height: cellWidth,
                  borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                ),
                const SizedBox(height: AppSpacing.xs),
                SkeletonWidget(
                  width: cellWidth * 0.6,
                  height: 12,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// "12 pairs · 4 favorites" with the grid layout toggle.
class ShoesCountRow extends StatelessWidget {
  final List<ShoesModel> shoes;
  final IconData gridIcon;
  final VoidCallback onToggleGrid;

  const ShoesCountRow({
    super.key,
    required this.shoes,
    required this.gridIcon,
    required this.onToggleGrid,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final int favorites = shoes.where((s) => s.isFavorite).length;
    return Row(
      children: [
        Expanded(
          child: Text(
            '${l10n.home_screen_pairs_count(shoes.length)} · '
            '${l10n.home_screen_favorites_count(favorites)}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          tooltip: l10n.a11y_toggle_grid,
          onPressed: onToggleGrid,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(gridIcon, key: ValueKey(gridIcon)),
          ),
        ),
      ],
    );
  }
}
