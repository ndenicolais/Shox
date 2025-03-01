import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

Future<void> requestStoragePermission(
  BuildContext context,
  Function pickImage,
) async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkVersion = androidInfo.version.sdkInt;

    // If SDK version is <= 32 (Android 12 or earlier)
    if (sdkVersion <= 32) {
      PermissionStatus filePermission = await Permission.storage.status;

      if (filePermission.isGranted) {
        pickImage();
      } else {
        filePermission = await Permission.storage.request();

        if (filePermission.isGranted) {
          return await pickImage();
        } else if (filePermission.isDenied) {
          if (context.mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!.permission_storage_denied,
            );
          }
          throw Exception('Storage permission denied');
        } else if (filePermission.isPermanentlyDenied) {
          if (context.mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!.permission_storage_toast,
            );
          }
          await Future.delayed(const Duration(milliseconds: 1200));
          openAppSettings();
          throw Exception('Storage permission permanently denied');
        }
      }
    }
    // If SDK version is >= 33 (Android 13+)
    else {
      PermissionStatus filePermission = await Permission.photos.status;

      if (filePermission.isGranted) {
        return await pickImage();
      } else if (filePermission.isDenied) {
        if (context.mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!.permission_storage_denied,
          );
        }
        throw Exception('Storage permission denied');
      } else if (filePermission.isPermanentlyDenied) {
        if (context.mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!.permission_storage_toast,
          );
        }
        await Future.delayed(const Duration(milliseconds: 1200));
        openAppSettings();
        throw Exception('Storage permission permanently denied');
      }
    }
  }
}

Future<String> requestManageExternalStoragePermission(
  BuildContext context,
) async {
  if (Platform.isAndroid) {
    PermissionStatus manageExternalStoragePermission =
        await Permission.manageExternalStorage.status;

    if (manageExternalStoragePermission.isGranted) {
      return 'Permission granted';
    } else {
      manageExternalStoragePermission =
          await Permission.manageExternalStorage.request();

      if (manageExternalStoragePermission.isGranted) {
        return 'Permission granted';
      } else if (manageExternalStoragePermission.isDenied) {
        if (context.mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!.permission_storage_denied,
          );
        }
        return 'Permission denied';
      } else if (manageExternalStoragePermission.isPermanentlyDenied) {
        if (context.mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!.permission_storage_toast,
          );
        }
        await Future.delayed(const Duration(milliseconds: 1200));
        openAppSettings();
        throw Exception('Storage permission permanently denied');
      }
    }
  }
  throw Exception('Unsupported platform');
}
