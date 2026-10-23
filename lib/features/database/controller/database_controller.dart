import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shox/features/database/models/shoes_statistics.dart';
import 'package:shox/features/database/repository/database_repository.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

/// Controller that manages business logic for database operations
class DatabaseController extends GetxController {
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

  /// All the collection statistics from a single read of the collection.
  Future<ShoesStatistics> getStatistics() async {
    try {
      return ShoesStatistics.fromShoes(await _repository.fetchShoes());
    } catch (e) {
      _logger.e('Error getting shoes statistics: $e');
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
}
