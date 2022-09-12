import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_binding.dart';
import 'core/config/config.dart';
import 'core/theme/theme.dart';
import 'core/utils/connectivity_util.dart';
import 'core/utils/keyboard_util.dart';
import 'routes/app_pages.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key) {
    ConnectivityUtil.configureConnectivityStream();
  }

  static final GlobalKey _appKey = GlobalKey();
  final logger = AppConfig.instance.logger;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => KeyboardUtil.hideKeyboard(context),
      child: GetMaterialApp(
        key: _appKey,
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        initialBinding: InitialBinding(),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        enableLog: kDebugMode,
        theme: Style.lightTheme,
        darkTheme: Style.darkTheme,
        themeMode: ThemeMode.dark,
        defaultTransition: Transition.fadeIn,
        logWriterCallback: (String text, {bool isError = false}) {
          // logger.i("GetXLog: $text");
          // debugPrint("GetXLog: $text");
        },
        navigatorObservers: <NavigatorObserver>[
          GetObserver(),
        ],
      ),
    );
  }
}
