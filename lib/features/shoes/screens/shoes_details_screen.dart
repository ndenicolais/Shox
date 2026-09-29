import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shox/common/widgets/delete_dialog_widget.dart';
import 'package:shox/common/widgets/empty_state_widget.dart';
import 'package:shox/common/widgets/error_state_widget.dart';
import 'package:shox/common/widgets/info_tile_widget.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/common/widgets/responsive_center_widget.dart';
import 'package:shox/common/widgets/skeleton_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/core/routes/app_routes.dart';
import 'package:shox/core/utils/shoes_text_translations.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/widgets/full_screen_image.dart';
import 'package:shox/features/shoes/widgets/shoes_colors_section.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:shox/theme/app_radius.dart';
import 'package:shox/theme/app_spacing.dart';

class ShoesDetailsScreen extends StatefulWidget {
  final String? shoesId;

  const ShoesDetailsScreen({super.key, this.shoesId});

  @override
  ShoesDetailsScreenState createState() => ShoesDetailsScreenState();
}

class ShoesDetailsScreenState extends State<ShoesDetailsScreen> {
  final ShoesController _shoesController = Get.find<ShoesController>();
  final ScreenshotController _screenshotController = ScreenshotController();
  late String currentLanguageCode;
  bool isShoesDeleted = false;
  late final String _resolvedShoesId;
  late final Stream<ShoesModel> _shoesStream;

  @override
  void initState() {
    super.initState();
    _resolvedShoesId = widget.shoesId ?? Get.arguments as String;
    _shoesStream = _shoesController.getShoesById(_resolvedShoesId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLanguageCode = Localizations.localeOf(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isShoesDeleted
          ? const Center(child: LoaderWidget(width: 50, height: 50))
          : StreamBuilder<ShoesModel>(
              stream: _shoesStream,
              builder: (context, snapshot) {
                final l10n = AppLocalizations.of(context)!;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LoaderWidget(width: 50, height: 50),
                  );
                }
                if (snapshot.hasError) {
                  return ErrorStateWidget(
                    message: l10n.shoes_details_screen_error_state,
                    onRetry: () => setState(() {}),
                  );
                }
                if (!snapshot.hasData) {
                  return EmptyStateWidget(
                    message: l10n.shoes_details_screen_empty_state,
                    icon: MingCuteIcons.mgc_shoe_line,
                    iconColor: Theme.of(context).colorScheme.secondary,
                  );
                }
                return _buildContent(context, snapshot.data!);
              },
            ),
    );
  }

  Widget _buildContent(BuildContext context, ShoesModel shoes) {
    return SafeArea(
      child: ResponsiveCenterWidget(
        child: Column(
          children: [
            _buildTopBar(context, shoes),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.l,
                  AppSpacing.xs,
                  AppSpacing.l,
                  AppSpacing.l,
                ),
                // Captured by "Share": photo and details, without buttons.
                child: Screenshot(
                  controller: _screenshotController,
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surface,
                    child: _buildDetails(context, shoes),
                  ),
                ),
              ),
            ),
            _buildActions(context, shoes),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ShoesModel shoes) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final circle = IconButton.styleFrom(
      backgroundColor: colors.surfaceContainerLowest,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          IconButton.filled(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            style: circle.copyWith(
              foregroundColor: WidgetStatePropertyAll(colors.onSurface),
            ),
            onPressed: () => Get.back(),
            icon: const Icon(MingCuteIcons.mgc_left_line),
          ),
          Expanded(
            child: Text(
              l10n.shoes_details_screen_title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton.filled(
            tooltip: shoes.isFavorite
                ? l10n.a11y_remove_from_favorites
                : l10n.a11y_add_to_favorites,
            style: circle.copyWith(
              foregroundColor: WidgetStatePropertyAll(colors.secondary),
            ),
            onPressed: () => _shoesController.toggleFavoriteStatus(
              shoes.id!,
              !shoes.isFavorite,
            ),
            icon: Icon(
              shoes.isFavorite
                  ? MingCuteIcons.mgc_heart_fill
                  : MingCuteIcons.mgc_heart_line,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context, ShoesModel shoes) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final String category = ShoesTextTranslations.translateCategory(
      shoes.category,
      currentLanguageCode,
    );
    final String type =
        ShoesTextTranslations.translateType(shoes.type, currentLanguageCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPhoto(context, shoes.imageUrl),
        const SizedBox(height: AppSpacing.l),
        Text(shoes.brand, style: textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '$category · $type',
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        Row(
          children: [
            Expanded(
              child: InfoTileWidget(
                label: l10n.shoes_details_screen_field_size,
                value: shoes.size,
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: InfoTileWidget(
                label: l10n.shoes_details_screen_field_season,
                value: ShoesTextTranslations.translateSeason(
                  shoes.season ?? 'All',
                  currentLanguageCode,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: InfoTileWidget(
                label: l10n.shoes_details_screen_field_added,
                value: DateFormat.yMMMd(currentLanguageCode)
                    .format(shoes.dateAdded),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        ShoesColorsSection(shoes: shoes),
        if (shoes.notes != null && shoes.notes!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.shoes_details_screen_field_note.toUpperCase(),
                    style: textTheme.labelSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(shoes.notes!, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhoto(BuildContext context, String imageUrl) {
    return Semantics(
      button: true,
      label: AppLocalizations.of(context)!.a11y_open_image,
      child: GestureDetector(
        onTap: () => Get.to(
          () => FullScreenImage(imageUrl: imageUrl),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        ),
        child: AspectRatio(
          aspectRatio: 1.2,
          child: Hero(
            tag: 'shoes-$_resolvedShoesId',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.hero),
              child: ColoredBox(
                color: Theme.of(context).colorScheme.tertiaryFixed,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SkeletonWidget(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Edit (primary), share and delete, pinned under the content.
  Widget _buildActions(BuildContext context, ShoesModel shoes) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final outlinedCircle = OutlinedButton.styleFrom(
      minimumSize: const Size(52, 52),
      fixedSize: const Size(52, 52),
      padding: EdgeInsets.zero,
      shape: const CircleBorder(),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.xs,
        AppSpacing.l,
        AppSpacing.m,
      ),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: () =>
                  Get.toNamed(AppRoutes.shoesUpdater, arguments: shoes),
              child: Text(l10n.shoes_details_screen_menu_edit),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Tooltip(
            message: l10n.shoes_details_screen_menu_share,
            child: OutlinedButton(
              style: outlinedCircle,
              onPressed: () => _shareScreenshot(context),
              child: const Icon(MingCuteIcons.mgc_share_2_line),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Tooltip(
            message: l10n.shoes_details_screen_menu_delete,
            child: OutlinedButton(
              style: outlinedCircle.copyWith(
                foregroundColor: WidgetStatePropertyAll(colors.error),
              ),
              onPressed: () => _deleteShoes(context, shoes),
              child: const Icon(MingCuteIcons.mgc_delete_2_line),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareScreenshot(BuildContext context) async {
    try {
      final String timestamp =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final image = await _screenshotController.capture();

      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        final imagePath = '${tempDir.path}/shox_shoes_$timestamp.png';
        final imageFile = File(imagePath)..writeAsBytesSync(image);

        final shareResult = await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: 'My shoes from Shox',
        );

        if (context.mounted) {
          if (shareResult.status == ShareResultStatus.success) {
            showSuccessToast(
              context,
              AppLocalizations.of(context)!.shoes_details_screen_share_success,
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!.shoes_details_screen_share_error,
        );
      }
    }
  }

  void _deleteShoes(BuildContext context, ShoesModel shoes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialogWidget(
          title:
              AppLocalizations.of(context)!.shoes_details_screen_delete_title,
          content: AppLocalizations.of(context)!
              .shoes_details_screen_delete_description,
          onCancelPressed: () {
            Get.back();
          },
          onConfirmPressed: () {
            _shoesController.deleteShoes(shoes);
            showSuccessToast(
              context,
              AppLocalizations.of(context)!
                  .shoes_details_screen_delete_toast_success,
            );
            setState(() {
              isShoesDeleted = true;
            });
            Get.back();
            Get.back();
          },
        );
      },
    );
  }
}
