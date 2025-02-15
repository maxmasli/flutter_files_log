import 'package:flutter_files_log/flutter_files_log.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  final dir = await getApplicationDocumentsDirectory();

  /// Initialization required
  FFL.init(
    dir: dir,
    fileName: "app_logs.txt",
    defaultTag: "DefaultTag",
    showDebugMessages: true,
    writeTimestampInFile: true,
    writeTimestampInConsole: false,
    enableWritingFiles: true,
  );

  /// INFO message
  FFL.i("info message", tag: "main");

  /// WARNING message
  FFL.w("warning message", tag: "main");

  try {
    throw Exception("Some exception");
  } catch (err, st) {
    /// ERROR message
    FFL.e("Something wrong", exception: err, stackTrace: st);
  }

  /// FATAL message
  FFL.f("fatal error");
}