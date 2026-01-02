import 'dart:ui';
import 'package:logger/logger.dart';
import 'package:shox/features/database/repository/database_repository.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

/// Controller that manages business logic for database operations
class DatabaseController {
  final Logger _logger = Logger();
  final DatabaseRepository _repository;

  DatabaseController({DatabaseRepository? repository})
      : _repository = repository ?? DatabaseRepository();

  /// Get all shoes for current user
  Future<List<ShoesModel>> getShoes() async {
    try {
      return await _repository.fetchShoes();
    } catch (e) {
      _logger.e('Error in getShoes: $e');
      rethrow;
    }
  }

  /// Get total count of shoes
  Future<int> getTotalShoesCount() async {
    try {
      final shoesList = await _repository.fetchShoes();
      return shoesList.length;
    } catch (e) {
      _logger.e('Error getting total shoes count: $e');
      rethrow;
    }
  }

  /// Get shoes count grouped by color
  Future<Map<String, int>> getShoesCountByColor() async {
    try {
      final shoesList = await _repository.fetchShoes();
      final Map<String, int> colorCounts = {};

      for (var shoes in shoesList) {
        String colorHex = shoes.colorPrimary.value.toRadixString(16);
        colorCounts[colorHex] = (colorCounts[colorHex] ?? 0) + 1;
      }

      _logger.i('Shoes count by color: $colorCounts');
      return colorCounts;
    } catch (e) {
      _logger.e('Error getting shoes count by color: $e');
      rethrow;
    }
  }

  /// Get shoes count grouped by brand
  Future<Map<String, int>> getShoesCountByBrand() async {
    try {
      final shoesList = await _repository.fetchShoes();
      final Map<String, int> brandCounts = {};

      for (var shoes in shoesList) {
        brandCounts[shoes.brand] = (brandCounts[shoes.brand] ?? 0) + 1;
      }

      _logger.i('Shoes count by brand: $brandCounts');
      return brandCounts;
    } catch (e) {
      _logger.e('Error getting shoes count by brand: $e');
      rethrow;
    }
  }

  /// Get shoes count grouped by category
  Future<Map<String, int>> getShoesCountByCategory() async {
    try {
      final shoesList = await _repository.fetchShoes();
      final Map<String, int> categoryCounts = {};

      for (var shoes in shoesList) {
        categoryCounts[shoes.category] =
            (categoryCounts[shoes.category] ?? 0) + 1;
      }

      _logger.i('Shoes count by category: $categoryCounts');
      return categoryCounts;
    } catch (e) {
      _logger.e('Error getting shoes count by category: $e');
      rethrow;
    }
  }

  /// Get shoes count grouped by type
  Future<Map<String, int>> getShoesCountByType() async {
    try {
      final shoesList = await _repository.fetchShoes();
      final Map<String, int> typeCounts = {};

      for (var shoes in shoesList) {
        typeCounts[shoes.type] = (typeCounts[shoes.type] ?? 0) + 1;
      }

      _logger.i('Shoes count by type: $typeCounts');
      return typeCounts;
    } catch (e) {
      _logger.e('Error getting shoes count by type: $e');
      rethrow;
    }
  }

  /// Get current user data
  Future<Map<String, dynamic>> getCurrentUserData() async {
    try {
      return await _repository.fetchCurrentUserData();
    } catch (e) {
      _logger.e('Error getting current user data: $e');
      rethrow;
    }
  }

  /// Get user account creation date
  Future<DateTime> getUserCreationDate(String userId) async {
    try {
      return await _repository.fetchUserCreationDate(userId);
    } catch (e) {
      _logger.e('Error getting user creation date: $e');
      rethrow;
    }
  }

  /// Get statistics summary for all shoes
  Future<Map<String, dynamic>> getShoesStatistics() async {
    try {
      final totalCount = await getTotalShoesCount();
      final colorCounts = await getShoesCountByColor();
      final brandCounts = await getShoesCountByBrand();
      final categoryCounts = await getShoesCountByCategory();
      final typeCounts = await getShoesCountByType();

      return {
        'totalCount': totalCount,
        'byColor': colorCounts,
        'byBrand': brandCounts,
        'byCategory': categoryCounts,
        'byType': typeCounts,
      };
    } catch (e) {
      _logger.e('Error getting shoes statistics: $e');
      rethrow;
    }
  }

  /// Get favorite brand (most used brand)
  Future<String?> getFavoriteBrand() async {
    try {
      final brandCounts = await getShoesCountByBrand();
      if (brandCounts.isEmpty) return null;

      final sortedBrands = brandCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedBrands.first.key;
    } catch (e) {
      _logger.e('Error getting favorite brand: $e');
      return null;
    }
  }

  /// Get most used category
  Future<String?> getMostUsedCategory() async {
    try {
      final categoryCounts = await getShoesCountByCategory();
      if (categoryCounts.isEmpty) return null;

      final sortedCategories = categoryCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedCategories.first.key;
    } catch (e) {
      _logger.e('Error getting most used category: $e');
      return null;
    }
  }

  /// Get most used type
  Future<String?> getMostUsedType() async {
    try {
      final typeCounts = await getShoesCountByType();
      if (typeCounts.isEmpty) return null;

      final sortedTypes = typeCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedTypes.first.key;
    } catch (e) {
      _logger.e('Error getting most used type: $e');
      return null;
    }
  }

  /// Get most used color (as Color object)
  Future<Color?> getMostUsedColorAsColor() async {
    try {
      final shoesList = await _repository.fetchShoes();
      if (shoesList.isEmpty) return null;

      final Map<String, int> colorCounts = {};
      for (var shoes in shoesList) {
        String colorHex = shoes.colorPrimary.value.toRadixString(16);
        colorCounts[colorHex] = (colorCounts[colorHex] ?? 0) + 1;
      }

      if (colorCounts.isEmpty) return null;

      final sortedColors = colorCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final hexColor = sortedColors.first.key;
      // Convert hex string back to Color
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (e) {
      _logger.e('Error getting most used color: $e');
      return null;
    }
  }

  /// Get most used color (as hex string)
  Future<String?> getMostUsedColor() async {
    try {
      final colorCounts = await getShoesCountByColor();
      if (colorCounts.isEmpty) return null;

      final sortedColors = colorCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedColors.first.key;
    } catch (e) {
      _logger.e('Error getting most used color: $e');
      return null;
    }
  }

  /// Get last shoe added (most recent dateAdded)
  Future<ShoesModel?> getLastShoeAdded() async {
    try {
      final shoesList = await _repository.fetchShoes();
      if (shoesList.isEmpty) return null;

      shoesList.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      return shoesList.first;
    } catch (e) {
      _logger.e('Error getting last shoe added: $e');
      return null;
    }
  }

  /// Get count of favorite shoes
  Future<int> getFavoriteShoesCount() async {
    try {
      final shoesList = await _repository.fetchShoes();
      return shoesList.where((shoe) => shoe.isFavorite).length;
    } catch (e) {
      _logger.e('Error getting favorite shoes count: $e');
      return 0;
    }
  }

  // ==================== EXPORT/IMPORT OPERATIONS ====================

  /// Export database to JSON with validation
  Future<ExportResult> exportDatabase() async {
    try {
      _logger.d('Starting database export...');

      // Check if directory is accessible
      final isAccessible = await _repository.isExportDirectoryAccessible();
      if (!isAccessible) {
        return ExportResult(
          success: false,
          message: 'Export directory not accessible',
        );
      }

      final filePath = await _repository.exportToJson();

      return ExportResult(
        success: true,
        message: 'Database exported successfully',
        filePath: filePath,
      );
    } catch (e) {
      _logger.e('Error in export database: $e');
      return ExportResult(
        success: false,
        message: 'Failed to export: ${e.toString()}',
      );
    }
  }

  /// Import database from JSON with validation
  Future<ImportResult> importDatabase(String userId,
      {Function(double)? onProgress}) async {
    try {
      _logger.d('Starting database import...');

      if (userId.isEmpty) {
        return ImportResult(
          success: false,
          message: 'User ID is required',
        );
      }

      await _repository.importFromJson(userId, onProgress: onProgress);

      return ImportResult(
        success: true,
        message: 'Database imported successfully',
      );
    } catch (e) {
      _logger.e('Error in import database: $e');

      // Check if it was cancelled
      if (e.toString().contains('cancelled')) {
        return ImportResult(
          success: false,
          message: 'Import cancelled',
          wasCancelled: true,
        );
      }

      return ImportResult(
        success: false,
        message: 'Failed to import: ${e.toString()}',
      );
    }
  }

  /// Share a file
  Future<bool> shareFile(String filePath) async {
    try {
      await _repository.shareFile(filePath);
      return true;
    } catch (e) {
      _logger.e('Error sharing file: $e');
      return false;
    }
  }

  /// Export and share database in one operation
  Future<ExportResult> exportAndShareDatabase() async {
    try {
      _logger.d('Starting export and share...');

      final exportResult = await exportDatabase();
      if (!exportResult.success || exportResult.filePath == null) {
        return exportResult;
      }

      final shared = await shareFile(exportResult.filePath!);
      if (!shared) {
        return ExportResult(
          success: false,
          message: 'Failed to share exported file',
          filePath: exportResult.filePath,
        );
      }

      return ExportResult(
        success: true,
        message: 'Database exported and shared successfully',
        filePath: exportResult.filePath,
      );
    } catch (e) {
      _logger.e('Error in export and share: $e');
      return ExportResult(
        success: false,
        message: 'Failed to export and share: ${e.toString()}',
      );
    }
  }
}

// ==================== RESULT CLASSES ====================

/// Result of an export operation
class ExportResult {
  final bool success;
  final String message;
  final String? filePath;

  ExportResult({
    required this.success,
    required this.message,
    this.filePath,
  });
}

/// Result of an import operation
class ImportResult {
  final bool success;
  final String message;
  final bool wasCancelled;

  ImportResult({
    required this.success,
    required this.message,
    this.wasCancelled = false,
  });
}
