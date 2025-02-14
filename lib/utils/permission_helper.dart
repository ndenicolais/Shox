import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/widgets/custom_toast_bar.dart';

Future<void> requestStoragePermission(
    BuildContext context, Function pickImage) async {
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
          pickImage();
        } else if (filePermission.isDenied) {
          if (context.mounted) {
            showErrorToast(
              context,
              S.current.storage_permission_error,
            );
          }
        } else if (filePermission.isPermanentlyDenied) {
          openAppSettings();
        }
      }
    }
    // If SDK version is >= 33 (Android 13+)
    else {
      PermissionStatus filePermission = await Permission.photos.status;

      if (filePermission.isGranted) {
        pickImage();
      } else {
        filePermission = await Permission.photos.request();

        if (filePermission.isGranted) {
          pickImage();
        } else if (filePermission.isDenied) {
          if (context.mounted) {
            showErrorToast(
              context,
              S.current.storage_permission_error,
            );
          }
        } else if (filePermission.isPermanentlyDenied) {
          openAppSettings();
        }
      }
    }
  }
}

Future<String> requestManageExternalStoragePermission(
    BuildContext context, Function pickImage) async {
  if (Platform.isAndroid) {
    PermissionStatus manageExternalStoragePermission =
        await Permission.manageExternalStorage.status;

    if (manageExternalStoragePermission.isGranted) {
      return await pickImage();
    } else {
      manageExternalStoragePermission =
          await Permission.manageExternalStorage.request();

      if (manageExternalStoragePermission.isGranted) {
        return await pickImage();
      } else if (manageExternalStoragePermission.isDenied) {
        if (context.mounted) {
          showErrorToast(
            context,
            S.current.storage_permission_error,
          );
        }
      } else if (manageExternalStoragePermission.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }
  throw Exception('Unsupported platform');
}
