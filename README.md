# flutter_files_log



`flutter_files_log` is a plugin for Flutter designed for logging to a file and console outputs. It supports configuring log levels, timestamps, and file logging.



## Installation



To install the plugin in your Flutter project, add the dependency to your `pubspec.yaml`:



```yaml
dependencies:
  flutter_files_log:
    git:
      url: https://github.com/maxmasli/flutter_files_log.git
      path: ./
```

## Initialization


Before using `FFL` you need to initialize this class. You can use the `path_provider` library to set the path to save the file


```dart
final dir = await getApplicationDocumentsDirectory();

FFL.init(
    dir: dir,
    fileName: "app_logs.txt",
    defaultTag: "DefaultTag",
    showDebugMessages: true,
    writeTimestampInFile: true,
    writeTimestampInConsole: false,
    enableWritingFiles: true,
  );
```

After this you can use the logs.

## Debug/Info/Warn/Error/Fatal logs

Here is an example of using logs.

```dart
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
```

File output:
```
2025-02-15T19:53:39.711616 [main] [INFO] info message

2025-02-15T19:53:39.726301 [main] [WARN] warning message

2025-02-15T19:53:39.726833 [DefaultTag] [ERROR] Something wrong
Exception: Some exception
#0      main (package:flutter_files_log_example/main.dart:25:5)
<asynchronous suspension>

2025-02-15T19:53:39.727916 [DefaultTag] [FATAL] fatal error
```
