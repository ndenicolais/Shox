/// Result of an export operation
class ExportResult {
  final bool success;
  final String message;
  final String? filePath;

  ExportResult({required this.success, required this.message, this.filePath});
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
