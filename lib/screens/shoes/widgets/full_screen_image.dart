import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shox/common/widgets/app_bar_widget.dart';
import 'package:shox/common/widgets/loader_widget.dart';
import 'package:shox/common/widgets/toast_widget.dart';

class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  FullScreenImageState createState() => FullScreenImageState();
}

class FullScreenImageState extends State<FullScreenImage> {
  String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: const AppBarWidget(title: ''),
      body: Stack(
        children: [
          Center(
            child: PhotoView(
              imageProvider: NetworkImage(widget.imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              loadingBuilder: (context, event) =>
                  LoaderWidget(width: 50.w, height: 50.h),
              backgroundDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (_isLoading) LoaderWidget(width: 50.w, height: 50.h),
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    MingCuteIcons.mgc_download_2_line,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 30.w,
                  ),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await _saveImage(context);
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                SizedBox(width: 20.w),
                IconButton(
                  icon: Icon(
                    MingCuteIcons.mgc_share_2_line,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 30.w,
                  ),
                  onPressed: () async {
                    await _shareImage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    try {
      final outputFile =
          'shox_${timestamp}_${widget.imageUrl.split('/').last.substring(widget.imageUrl.split('/').last.length - 8)}';
      final response = await http.get(Uri.parse(widget.imageUrl));
      if (response.statusCode == 200) {
        final result = await ImageGallerySaverPlus.saveImage(
          Uint8List.fromList(response.bodyBytes),
          quality: 100,
          name: outputFile,
        );
        if (result['isSuccess']) {
          if (context.mounted) {
            showSuccessToast(
              context,
              AppLocalizations.of(context)!
                  .full_screen_image_save_success_toast,
            );
          }
        } else {
          if (context.mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!.full_screen_image_save_error_toast,
            );
          }
        }
      } else {
        if (context.mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!
                .full_screen_image_download_error_toast,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(context,
            "${AppLocalizations.of(context)!.full_screen_image_download_error_toast} $e");
      }
    }
  }

  Future<void> _shareImage() async {
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = await File(
                '${tempDir.path}/shox_${timestamp}_${widget.imageUrl.split('/').last.substring(widget.imageUrl.split('/').last.length - 8)}')
            .create();
        file.writeAsBytesSync(response.bodyBytes);

        final shareResult = await Share.shareXFiles([XFile(file.path)],
            text: AppLocalizations.of(context)!.full_screen_image_share_text);

        if (mounted) {
          if (shareResult.status == ShareResultStatus.success) {
            showSuccessToast(
              context,
              AppLocalizations.of(context)!
                  .full_screen_image_share_success_toast,
            );
          } else if (shareResult.status == ShareResultStatus.dismissed) {
          } else {
            showErrorToast(
              context,
              AppLocalizations.of(context)!.full_screen_image_share_error_toast,
            );
          }
        }
      } else {
        if (mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!
                .full_screen_image_share_download_error_toast,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(context,
            "${AppLocalizations.of(context)!.full_screen_image_share_error_toast} $e");
      }
    }
  }
}
