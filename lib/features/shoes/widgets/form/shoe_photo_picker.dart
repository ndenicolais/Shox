import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/theme/app_spacing.dart';

/// Asks whether to take a photo or pick one from the gallery.
Future<ImageSource?> showImageSourceSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.m),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(MingCuteIcons.mgc_camera_2_line),
              title: Text(l10n.a11y_take_photo),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(MingCuteIcons.mgc_photo_album_2_line),
              title: Text(l10n.a11y_pick_from_gallery),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Blocking progress dialog shown while the photo background is removed.
class BackgroundRemovalDialog extends StatelessWidget {
  const BackgroundRemovalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(AppSpacing.xl),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.tertiaryFixed,
              child: Icon(
                MingCuteIcons.mgc_magic_2_line,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            const LoaderWidget(width: 48, height: 48),
            const SizedBox(height: AppSpacing.l),
            Text(
              AppLocalizations.of(context)!.shoes_form_screen_bg_remove_loading,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Large photo area of the shoe form: empty state, the newly picked photo
/// (optionally without background) or the stored one; only one is shown.
class ShoePhotoArea extends StatelessWidget {
  final File? newImage;
  final Uint8List? noBackgroundBytes;
  final String? existingImageUrl;

  /// Whether the "remove background" action is offered.
  final bool canRemoveBackground;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onRemoveBackground;

  const ShoePhotoArea({
    super.key,
    required this.newImage,
    required this.noBackgroundBytes,
    required this.existingImageUrl,
    required this.canRemoveBackground,
    required this.onTap,
    required this.onRemove,
    required this.onRemoveBackground,
  });

  Widget? get _photo {
    if (newImage != null) {
      return noBackgroundBytes != null
          ? Image.memory(noBackgroundBytes!, fit: BoxFit.cover)
          : Image.file(newImage!, fit: BoxFit.cover);
    }
    if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
      return Image.network(existingImageUrl!, fit: BoxFit.cover);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final Widget? photo = _photo;

    return AspectRatio(
      aspectRatio: 1.2,
      child: Material(
        color: colors.tertiaryFixed,
        borderRadius: BorderRadius.circular(AppRadius.hero),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: photo == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: colors.surface,
                      child: Icon(
                        MingCuteIcons.mgc_camera_2_line,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      l10n.shoes_form_screen_add_photo,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    photo,
                    Positioned(
                      top: AppSpacing.s,
                      right: AppSpacing.s,
                      child: IconButton(
                        tooltip: l10n.a11y_remove_image,
                        style: IconButton.styleFrom(
                          backgroundColor:
                              colors.surface.withValues(alpha: 0.9),
                          foregroundColor: colors.onSurface,
                        ),
                        onPressed: onRemove,
                        icon: const Icon(MingCuteIcons.mgc_close_line),
                      ),
                    ),
                    if (canRemoveBackground)
                      Positioned(
                        left: AppSpacing.s,
                        bottom: AppSpacing.s,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                colors.surface.withValues(alpha: 0.9),
                            foregroundColor: colors.onSurface,
                            minimumSize: const Size(0, 44),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.m,
                            ),
                          ),
                          onPressed: onRemoveBackground,
                          icon: const Icon(MingCuteIcons.mgc_eraser_line),
                          label: Text(l10n.a11y_remove_background),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
