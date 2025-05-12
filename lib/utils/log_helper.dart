// lib/utils/log_helper.dart
import 'dart:async';
import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    colors: true,
    printEmojis: true,
    lineLength: 100,
    printTime: true,
  ),
);

void logInfo(dynamic message, {String? tag}) =>
    _logger.i(_format(message, tag));

void logError(dynamic message, {String? tag, dynamic error, StackTrace? stackTrace}) =>
    _logger.e(_format(message, tag), error: error, stackTrace: stackTrace);

void logWarning(dynamic message, {String? tag}) =>
    _logger.w(_format(message, tag));

void logDebug(dynamic message, {String? tag}) =>
    _logger.d(_format(message, tag));

void logVerbose(dynamic message, {String? tag}) =>
    _logger.v(_format(message, tag));

/// 🐞 Автоматический баг-репорт в терминал
void logBugToConsole(
  String message, {
  String? tag,
  dynamic error,
  StackTrace? stackTrace,
}) {
  final time = DateTime.now().toIso8601String();
  final formattedTag = tag != null ? '[$tag]' : '';
  final buffer = StringBuffer();

  buffer.writeln('\n════════════════════════════════════════════');
  buffer.writeln('🐞 BUG REPORT $formattedTag');
  buffer.writeln('⏰ $time');
  buffer.writeln('📄 Сообщение: $message');
  if (error != null) buffer.writeln('💥 Ошибка: $error');
  if (stackTrace != null) buffer.writeln('📌 Stack Trace:\n$stackTrace');
  buffer.writeln('════════════════════════════════════════════\n');

  print(buffer.toString());

  logError(message, tag: tag, error: error, stackTrace: stackTrace);
}

/// Приватный хелпер для добавления префикса (тега).
String _format(dynamic message, String? tag) {
  if (tag != null && tag.isNotEmpty) {
    return '[$tag] $message';
  }
  return message.toString();
}


