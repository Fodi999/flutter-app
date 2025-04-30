// lib/utils/log_helper.dart
import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    colors: true,
    printEmojis: true,
    // Вместо устаревшего printTime используем dateTimeFormat
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

void logInfo(String message) => _logger.i(message);
void logError(String message) => _logger.e(message);
void logWarning(String message) => _logger.w(message);
void logDebug(String message) => _logger.d(message);
