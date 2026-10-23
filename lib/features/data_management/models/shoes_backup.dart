import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:shox/features/shoes/models/shoes_model.dart';

/// Thrown when a picked file is not a backup this app version can restore.
class BackupFormatException implements Exception {
  /// `not_a_backup`, `unsupported_version` or `corrupted`.
  final String code;
  final String? message;

  const BackupFormatException(this.code, [this.message]);

  @override
  String toString() =>
      'BackupFormatException($code)${message != null ? ': $message' : ''}';
}

/// Summary stored as `manifest.json` at the root of the archive.
class BackupManifest {
  final int formatVersion;
  final DateTime? createdAt;
  final int shoesCount;
  final String? appVersion;

  const BackupManifest({
    required this.formatVersion,
    required this.createdAt,
    required this.shoesCount,
    this.appVersion,
  });

  Map<String, dynamic> toJson() => {
        'formatVersion': formatVersion,
        'createdAt': createdAt?.toIso8601String(),
        'shoesCount': shoesCount,
        'appVersion': appVersion,
      };
}

/// One shoe of a backup with its photo.
///
/// ZIP backups carry the photo in [image]; legacy JSON exports only have
/// the [legacyImageUrl] of the photo that was online when they were made.
class BackupShoe {
  final ShoesModel shoe;
  final Uint8List? image;
  final String imageExtension;
  final String? legacyImageUrl;

  const BackupShoe({
    required this.shoe,
    this.image,
    this.imageExtension = '.jpg',
    this.legacyImageUrl,
  });

  bool get hasImage => image != null || legacyImageUrl != null;
}

/// A self-contained backup of the shoes collection:
///
/// ```text
/// shox_backup_<date>.zip
/// ├── manifest.json   formatVersion, createdAt, shoesCount, appVersion
/// ├── shoes.json      list of shoes, each with an optional "image" path
/// └── images/         one photo per shoe (images/<index><ext>)
/// ```
///
/// [decode] also accepts the JSON list written by the old export (before
/// 5.0.0), whose photos are still referenced by URL.
class ShoesBackup {
  static const int currentFormatVersion = 1;
  static const String manifestFile = 'manifest.json';
  static const String shoesFile = 'shoes.json';
  static const String imagesDir = 'images/';

  final BackupManifest manifest;
  final List<BackupShoe> shoes;
  final bool isLegacy;

  const ShoesBackup({
    required this.manifest,
    required this.shoes,
    this.isLegacy = false,
  });

  /// Builds the ZIP archive. Photos are stored without compression since
  /// they are already compressed images.
  Uint8List encode() {
    final archive = Archive();
    final entries = <Map<String, dynamic>>[];

    for (var i = 0; i < shoes.length; i++) {
      final backupShoe = shoes[i];
      final json = backupShoe.shoe.toJson()..remove('imageUrl');
      final image = backupShoe.image;
      if (image != null) {
        final name = '$imagesDir$i${backupShoe.imageExtension}';
        archive.addFile(ArchiveFile.noCompress(name, image.length, image));
        json['image'] = name;
      } else {
        json['image'] = null;
      }
      entries.add(json);
    }

    archive.addFile(ArchiveFile.string(shoesFile, jsonEncode(entries)));
    archive.addFile(
      ArchiveFile.string(manifestFile, jsonEncode(manifest.toJson())),
    );
    return ZipEncoder().encodeBytes(archive);
  }

  /// Reads and fully validates [bytes] (ZIP backup or legacy JSON export)
  /// before anything is written, so a bad file never touches the data.
  ///
  /// Throws [BackupFormatException].
  static ShoesBackup decode(Uint8List bytes) {
    if (_isZip(bytes)) return _decodeZip(bytes);
    return _decodeLegacyJson(bytes);
  }

  /// ZIP local file header signature "PK\x03\x04".
  static bool _isZip(Uint8List bytes) =>
      bytes.length >= 4 &&
      bytes[0] == 0x50 &&
      bytes[1] == 0x4B &&
      bytes[2] == 0x03 &&
      bytes[3] == 0x04;

  static ShoesBackup _decodeZip(Uint8List bytes) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes, verify: true);
    } catch (e) {
      throw BackupFormatException('corrupted', '$e');
    }

    final manifestJson = _readJson(archive, manifestFile);
    if (manifestJson is! Map<String, dynamic>) {
      throw const BackupFormatException('not_a_backup', 'Missing manifest');
    }
    final version = manifestJson['formatVersion'];
    if (version is! int) {
      throw const BackupFormatException('not_a_backup', 'No format version');
    }
    if (version > currentFormatVersion) {
      throw BackupFormatException('unsupported_version', 'v$version');
    }

    final entries = _readJson(archive, shoesFile);
    if (entries is! List) {
      throw const BackupFormatException('corrupted', 'Missing shoes list');
    }

    final shoes = <BackupShoe>[];
    for (final entry in entries) {
      final data = _validShoeEntry(entry);
      final imagePath = data['image'];
      Uint8List? image;
      if (imagePath != null) {
        if (imagePath is! String) {
          throw const BackupFormatException('corrupted', 'Bad image path');
        }
        image = _readBytes(archive, imagePath);
        if (image == null) {
          throw BackupFormatException('corrupted', 'Missing $imagePath');
        }
      }
      shoes.add(
        BackupShoe(
          shoe: ShoesModel.fromJson('', data),
          image: image,
          imageExtension:
              imagePath is String ? _extensionOf(imagePath) : '.jpg',
        ),
      );
    }

    final count = manifestJson['shoesCount'];
    if (count is int && count != shoes.length) {
      throw BackupFormatException(
        'corrupted',
        'Expected $count shoes, found ${shoes.length}',
      );
    }

    final createdAt = manifestJson['createdAt'];
    final appVersion = manifestJson['appVersion'];
    return ShoesBackup(
      manifest: BackupManifest(
        formatVersion: version,
        createdAt: createdAt is String ? DateTime.tryParse(createdAt) : null,
        shoesCount: shoes.length,
        appVersion: appVersion is String ? appVersion : null,
      ),
      shoes: shoes,
    );
  }

  static ShoesBackup _decodeLegacyJson(Uint8List bytes) {
    final dynamic entries;
    try {
      entries = jsonDecode(utf8.decode(bytes));
    } catch (_) {
      throw const BackupFormatException('not_a_backup');
    }
    if (entries is! List) {
      throw const BackupFormatException('not_a_backup');
    }

    final shoes = entries.map((entry) {
      final data = _validShoeEntry(entry);
      final url = data['imageUrl'];
      final hasUrl = url is String && url.isNotEmpty;
      return BackupShoe(
        shoe: ShoesModel.fromJson('', data),
        legacyImageUrl: hasUrl ? url : null,
        imageExtension: hasUrl ? extensionOfUrl(url) : '.jpg',
      );
    }).toList();

    return ShoesBackup(
      manifest: BackupManifest(
        formatVersion: 0,
        createdAt: null,
        shoesCount: shoes.length,
      ),
      shoes: shoes,
      isLegacy: true,
    );
  }

  /// Null when [name] is not in the archive; a failed CRC check or a
  /// truncated entry is reported as `corrupted`.
  static Uint8List? _readBytes(Archive archive, String name) {
    try {
      return archive.findFile(name)?.readBytes();
    } catch (e) {
      throw BackupFormatException('corrupted', '$name: $e');
    }
  }

  static dynamic _readJson(Archive archive, String name) {
    final bytes = _readBytes(archive, name);
    if (bytes == null) return null;
    try {
      return jsonDecode(utf8.decode(bytes));
    } catch (e) {
      throw BackupFormatException('corrupted', '$name: $e');
    }
  }

  /// A shoe entry must at least be an object with a brand and a category:
  /// this rejects unrelated JSON files instead of importing empty shoes.
  static Map<String, dynamic> _validShoeEntry(dynamic entry) {
    if (entry is Map<String, dynamic> &&
        entry['brand'] is String &&
        entry['category'] is String) {
      return entry;
    }
    throw const BackupFormatException('not_a_backup', 'Invalid shoe entry');
  }

  static String _extensionOf(String name) {
    final ext = p.extension(name).toLowerCase();
    return ext.isEmpty ? '.jpg' : ext;
  }

  /// Storage download URLs keep the object path URL-encoded in the last
  /// segment (`.../o/uid%2Fshoes%2Fid%2Fphoto.png?alt=media`).
  static String extensionOfUrl(String url) {
    final segments = Uri.tryParse(url)?.pathSegments ?? const [];
    if (segments.isEmpty) return '.jpg';
    return _extensionOf(Uri.decodeComponent(segments.last));
  }
}
