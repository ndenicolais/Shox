import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/services/downloads_service.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/data_management/models/shoes_backup.dart';
import 'package:shox/features/data_management/repository/backup_repository.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

/// A backup written to the app cache and copied to Download/Shox.
class SavedBackup {
  final String filePath;
  final String location;
  final int shoesCount;
  final int missingImages;

  const SavedBackup({
    required this.filePath,
    required this.location,
    required this.shoesCount,
    required this.missingImages,
  });
}

class RestoreResult {
  final int restoredCount;

  /// Shoes restored without a photo because it could not be downloaded
  /// (legacy JSON exports only).
  final int missingImages;

  const RestoreResult({
    required this.restoredCount,
    required this.missingImages,
  });
}

/// Creates and restores self-contained backups of the shoes collection.
class BackupController extends GetxController {
  final Logger _logger = Logger();
  final BackupRepository _repository;

  /// The repository defaults to the real one; tests can pass a fake.
  BackupController({BackupRepository? repository})
      : _repository = repository ?? BackupRepository();

  /// Last backup made from this device by the signed-in user.
  final Rxn<DateTime> lastBackupAt = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    loadLastBackupDate();
  }

  String get _lastBackupKey =>
      '${AppConstants.prefsLastBackupPrefix}${_repository.userId}';

  Future<void> loadLastBackupDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_lastBackupKey);
      lastBackupAt.value = value == null ? null : DateTime.tryParse(value);
    } catch (e) {
      _logger.w('Could not read the last backup date: $e');
    }
  }

  // ========== BACKUP ==========

  /// Reads every shoe and downloads its photo. [onProgress] goes from 0 to 1.
  Future<ShoesBackup> buildBackup({
    required void Function(double) onProgress,
    String? appVersion,
  }) async {
    final shoes = await _repository.fetchShoes();
    final entries = <BackupShoe>[];

    for (var i = 0; i < shoes.length; i++) {
      final shoe = shoes[i];
      final image = shoe.imageUrl.isEmpty
          ? null
          : await _repository.downloadImage(shoe.imageUrl);
      entries.add(
        BackupShoe(
          shoe: shoe,
          image: image,
          imageExtension: ShoesBackup.extensionOfUrl(shoe.imageUrl),
        ),
      );
      onProgress((i + 1) / shoes.length);
    }

    return ShoesBackup(
      manifest: BackupManifest(
        formatVersion: ShoesBackup.currentFormatVersion,
        createdAt: DateTime.now(),
        shoesCount: entries.length,
        appVersion: appVersion,
      ),
      shoes: entries,
    );
  }

  /// Builds the backup, saves it to Download/Shox and remembers its date.
  Future<SavedBackup> createBackup({
    required void Function(double) onProgress,
  }) async {
    final info = await PackageInfo.fromPlatform();
    // 90% for reading the collection, the rest for zipping and saving.
    final backup = await buildBackup(
      onProgress: (progress) => onProgress(progress * 0.9),
      appVersion: info.version,
    );

    final directory = await getTemporaryDirectory();
    final date = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File(p.join(directory.path, 'shox_backup_$date.zip'));
    await file.writeAsBytes(backup.encode());
    final location = await DownloadsService.saveToDownloads(
      file.path,
      mimeType: 'application/zip',
    );

    final now = DateTime.now();
    lastBackupAt.value = now;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastBackupKey, now.toIso8601String());
    } catch (e) {
      _logger.w('Could not store the last backup date: $e');
    }
    onProgress(1);

    final missing = backup.shoes
        .where((entry) => entry.shoe.imageUrl.isNotEmpty && entry.image == null)
        .length;
    _logger.i('Backup saved to $location (${backup.shoes.length} shoes)');
    return SavedBackup(
      filePath: file.path,
      location: location,
      shoesCount: backup.shoes.length,
      missingImages: missing,
    );
  }

  Future<void> shareFile(String filePath) async {
    await SharePlus.instance.share(ShareParams(files: [XFile(filePath)]));
  }

  // ========== RESTORE ==========

  /// Validates a picked file. Throws [BackupFormatException].
  ShoesBackup readBackup(Uint8List bytes) => ShoesBackup.decode(bytes);

  Future<int> currentShoesCount() async =>
      (await _repository.fetchShoes()).length;

  /// Replaces the whole collection with [backup].
  ///
  /// The new shoes and photos are written first and the current ones are
  /// deleted only afterwards: if anything fails along the way, what was
  /// already uploaded is rolled back and the current collection is left
  /// untouched.
  Future<RestoreResult> restoreBackup(
    ShoesBackup backup, {
    required void Function(double) onProgress,
  }) async {
    final current = await _repository.fetchShoes();
    final restored = <ShoesModel>[];
    final uploadedUrls = <String>[];
    var missingImages = 0;
    // 80% for photos, 10% for writing, 10% for removing the old collection.
    final total = backup.shoes.isEmpty ? 1 : backup.shoes.length;

    try {
      for (var i = 0; i < backup.shoes.length; i++) {
        final entry = backup.shoes[i];
        final id = _repository.newShoesId();
        final Uint8List? image = entry.image ??
            (entry.legacyImageUrl == null
                ? null
                : await _repository.downloadImage(entry.legacyImageUrl!));

        var imageUrl = '';
        if (image != null) {
          imageUrl = await _repository.uploadImage(
            shoesId: id,
            bytes: image,
            extension: entry.imageExtension,
          );
          uploadedUrls.add(imageUrl);
        } else if (entry.hasImage) {
          missingImages++;
        }

        restored.add(entry.shoe.copyWith(id: id, imageUrl: imageUrl));
        onProgress((i + 1) / total * 0.8);
      }

      await _repository.writeShoes(restored);
      onProgress(0.9);
    } catch (e) {
      _logger.e('Restore failed, rolling back: $e');
      await _rollback(restored, uploadedUrls);
      rethrow;
    }

    await _repository.deleteShoes(current.map((shoe) => shoe.id!).toList());
    for (final shoe in current) {
      if (shoe.imageUrl.isNotEmpty) {
        await _repository.deleteImage(shoe.imageUrl);
      }
    }
    onProgress(1);

    _logger.i('Restored ${restored.length} shoes ($missingImages w/o photo)');
    return RestoreResult(
      restoredCount: restored.length,
      missingImages: missingImages,
    );
  }

  /// Removes what a failed restore already wrote. A batch may have been
  /// committed before the failure, so the documents are deleted as well.
  Future<void> _rollback(List<ShoesModel> restored, List<String> urls) async {
    try {
      await _repository.deleteShoes(restored.map((shoe) => shoe.id!).toList());
    } catch (e) {
      _logger.w('Rollback of restored documents failed: $e');
    }
    for (final url in urls) {
      await _repository.deleteImage(url);
    }
  }
}
