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


Before using `FFL` you need to initialize this class.

```dart
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