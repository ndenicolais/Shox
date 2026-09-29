import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/skeleton_widget.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/theme/app_spacing.dart';

/// Grid card: square photo with a favorite toggle, brand and size/type below.
class ShoeCard extends StatelessWidget {
  final ShoesModel shoe;

  /// Translated type label shown next to the size.
  final String typeLabel;

  /// Width of the grid cell; sizes the decoded thumbnail.
  final double cellWidth;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const ShoeCard({
    super.key,
    required this.shoe,
    required this.typeLabel,
    required this.cellWidth,
    required this.onTap,
    required this.onToggleFavorite,
  });

  /// Height of the text block under the photo at the current text scale,
  /// used by the grid to size each cell (photo is square).
  static double captionHeight(BuildContext context) =>
      AppSpacing.xs + MediaQuery.textScalerOf(context).scale(40);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'shoes-${shoe.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                    child: ColoredBox(
                      color: theme.colorScheme.tertiaryFixed,
                      child: _buildImage(context),
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: IconButton(
                    tooltip: shoe.isFavorite
                        ? l10n.a11y_remove_from_favorites
                        : l10n.a11y_add_to_favorites,
                    style: IconButton.styleFrom(
                      backgroundColor:
                          theme.colorScheme.surface.withValues(alpha: 0.85),
                      minimumSize: const Size(36, 36),
                      fixedSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                    ),
                    icon: Icon(
                      shoe.isFavorite
                          ? MingCuteIcons.mgc_heart_fill
                          : MingCuteIcons.mgc_heart_line,
                      size: 18,
                      color: theme.colorScheme.secondary,
                    ),
                    onPressed: onToggleFavorite,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shoe.brand,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${l10n.home_screen_card_size(shoe.size)} · $typeLabel',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Decodes the thumbnail at the cell width instead of the full photo size.
  Widget _buildImage(BuildContext context) {
    final int cacheWidth =
        (cellWidth * MediaQuery.devicePixelRatioOf(context)).round();

    if (shoe.imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: shoe.imageUrl,
        memCacheWidth: cacheWidth,
        fit: BoxFit.cover,
        placeholder: (context, url) => const SkeletonWidget(),
        errorWidget: (context, url, error) => Icon(
          MingCuteIcons.mgc_close_line,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    return Image.asset(
      shoe.imageUrl,
      cacheWidth: cacheWidth,
      fit: BoxFit.cover,
    );
  }
}
