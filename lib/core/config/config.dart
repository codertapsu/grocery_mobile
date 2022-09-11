import 'package:logger/logger.dart';

class AppConfig {
  static String apiBaseUrl = 'http://192.168.1.8:3030/api';
  static String appName = 'Tạp hoá PK';

  late final Logger logger;

  static final AppConfig instance = AppConfig._internal();
  factory AppConfig() => instance;
  AppConfig._internal() {
    logger = Logger(
      printer: PrettyPrinter(
        // number of method calls to be displayed
        methodCount: 2,
        // number of method calls if stacktrace is provided
        errorMethodCount: 8,
        // width of the output
        lineLength: 120,
        // Colorful log messages
        colors: true,
        // Print an emoji for each log message
        printEmojis: true,
        // Should each log print contain a timestamp
        printTime: false,
      ),
    );
  }
}
