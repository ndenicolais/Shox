import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Copies files into the public Download/Shox folder through MediaStore
/// (native channel in `MainActivity.kt`), so they show up in the Files app
/// and survive an uninstall.
class DownloadsService {
  static const MethodChannel _channel =
      MethodChannel('com.ndn21.shox/downloads');

  /// Saves [filePath] to Download/Shox and returns the location shown to the
  /// user (e.g. `Download/Shox/shox_db_20261002_101500.pdf`).
  ///
  /// Android 9 and lower need the storage permission; Android 10+ writes
  /// through MediaStore without any permission.
  ///
  /// Throws when the permission is denied or the copy fails.
  static Future<String> saveToDownloads(
    String filePath, {
    required String mimeType,
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('Public downloads are only supported on Android');
    }

    final sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    if (sdkInt < 29 && !(await Permission.storage.request()).isGranted) {
      throw Exception('Storage permission denied');
    }

    final location = await _channel.invokeMethod<String>(
      'saveToDownloads',
      {'path': filePath, 'mimeType': mimeType},
    );
    if (location == null) throw Exception('Save to downloads failed');
    return location;
  }
}
