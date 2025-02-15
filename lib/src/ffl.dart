import 'dart:developer';
import 'dart:io';

abstract class FFL {
  static bool _isInitialized = false;
  static late File _file;

  static late bool _showDebugMessages;
  static late bool _enableWritingFiles;
  static late bool _writeTimestampInFile;
  static late bool _writeTimestampInConsole;
  static late String _defaultTag;

  static final _logQueue = <Future<void>>[];

  static void init({
    required Directory dir,
    required String fileName,
    String defaultTag = "FFL",
    bool showDebugMessages = true,
    bool writeTimestampInFile = true,
    bool writeTimestampInConsole = false,
    bool enableWritingFiles = true,
  }) {
    if (_isInitialized) {
      log("FFL is initialized already", name: "FFL");
      return;
    }
    _file = File("${dir.path}/$fileName");
    _defaultTag = defaultTag;
    _showDebugMessages = showDebugMessages;
    _writeTimestampInFile = writeTimestampInFile;
    _writeTimestampInConsole = writeTimestampInConsole;
    _enableWritingFiles = enableWritingFiles;
    _isInitialized = true;
  }

  static void _enqueueLog(Future<void> Function() logFunction) {
    final previous = _logQueue.isEmpty ? Future.value() : _logQueue.last;
    final logTask = previous.then((_) => logFunction());
    _logQueue.add(logTask);
  }

  static void d(String message, {String? tag}) {
    _enqueueLog(() => _writeLog(LogLevel.debug, message, tag));
  }

  static void i(String message, {String? tag}) {
    _enqueueLog(() => _writeLog(LogLevel.info, message, tag));
  }

  static void w(String message, {String? tag}) {
    _enqueueLog(() => _writeLog(LogLevel.warn, message, tag));
  }

  static void e(
    String message, {
    String? tag,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    _enqueueLog(
        () => _writeLog(LogLevel.error, message, tag, exception, stackTrace));
  }

  static void f(
    String message, {
    String? tag,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    _enqueueLog(
        () => _writeLog(LogLevel.fatal, message, tag, exception, stackTrace));
  }

  static Future<void> _writeLog(
    LogLevel level,
    String message,
    String? tag, [
    Object? exception,
    StackTrace? stackTrace,
  ]) async {
    assert(_isInitialized, "FFL is not initialized");
    if (!_showDebugMessages && level == LogLevel.debug) return;

    final timestamp = DateTime.now();

    /// Example:
    /// [INFO] message
    final rawMessage = "${level.tag} $message";

    var consoleMessage = _buildConsoleMessage(
      rawMessage: rawMessage,
      timestamp: timestamp,
    );

    log(
      consoleMessage,
      name: tag ?? _defaultTag,
      time: timestamp,
      level: level.value,
      error: exception,
      stackTrace: stackTrace,
    );

    if (!_enableWritingFiles) return;

    var fileMessage = _buildFileMessage(
      rawMessage: rawMessage,
      timestamp: timestamp,
      tag: tag,
      exception: exception,
      stackTrace: stackTrace,
    );

    await _file.writeAsString(fileMessage, mode: FileMode.append);
  }

  static String _buildConsoleMessage({
    required String rawMessage,
    required DateTime timestamp,
  }) {
    /// Example:
    /// [INFO] message
    var msg = rawMessage;
    if (_writeTimestampInConsole) {
      /// Example:
      /// 2025-02-15T03:57:29.453656 [INFO] message
      msg = "${timestamp.toIso8601String()} $rawMessage";
    }
    return msg;
  }

  static String _buildFileMessage({
    required String rawMessage,
    required DateTime timestamp,
    String? tag,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    /// Example:
    /// [TAG] [INFO] message
    var msg = "[${tag ?? _defaultTag}] $rawMessage\n";
    if (_writeTimestampInFile) {
      /// Example:
      /// 2025-02-15T03:57:29.453656 [TAG] [INFO] message
      msg = "${timestamp.toIso8601String()} $msg";
    }

    if (exception != null || stackTrace != null) {
      /// Example:
      /// [FFL] [ERROR] something happened
      /// Exception: This is exception
      /// #0      main (package:flutter_files_log_example/main.dart:20:5)
      /// <asynchronous suspension>
      msg += "${exception.toString()}\n${stackTrace.toString()}";
    }
    msg += "\n";
    return msg;
  }
}

enum LogLevel {
  debug(700, "[DEBUG]"),
  info(800, "[INFO]"),
  warn(900, "[WARN]"),
  error(1000, "[ERROR]"),
  fatal(1100, "[FATAL]");

  final int value;
  final String tag;

  const LogLevel(this.value, this.tag);
}
