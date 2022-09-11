import 'package:flutter/material.dart';

// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'core/config/config.dart';
import 'core/utils/storage_util.dart';

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig();
  await GetStorage.init();
  await StorageUtil.init();
  // await SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     // DeviceOrientation.portraitDown,
  //   ],
  // );
}

void main() async {
  await initialize();
  runApp(MyApp());
}
