import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../config/config.dart';
import '../theme/colors.dart';
import '../utils/biometric_util.dart';

class SettingsController extends GetxController with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  final _logger = AppConfig.instance.logger;

  final _isBiometricAuth = RxBool(false);
  set isBiometricAuth(bool value) => _isBiometricAuth.value = value;
  bool get isBiometricAuth => _isBiometricAuth.value;

  final _language = RxString('VN');
  set language(String value) => _language.value = value;
  String get language => _language.value;

  final _appLifecycleState = Rx<AppLifecycleState>(AppLifecycleState.resumed);
  set appLifecycleState(AppLifecycleState value) =>
      _appLifecycleState.value = value;
  AppLifecycleState get appLifecycleState => _appLifecycleState.value;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);

    /// WidgetsBinding.instance?.lifecycleState
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    _appLifecycleState.value = state;
    _logger.i(state);

    if (state == AppLifecycleState.resumed && isBiometricAuth == true) {
      var isDeviceSupported = await BiometricUtil().isDeviceSupported();
      if (isDeviceSupported) {
        var dialog = await Get.defaultDialog(
          barrierDismissible: false,
          title: 'Log on with Biometrics',
          content: Column(
            children: const [
              Text('Please scan your biometric to log onto your app'),
              SizedBox(height: 15),
              Icon(
                Ionicons.ios_finger_print,
                color: ThemeColors.primaryTextColorDark,
                size: 80,
              ),
            ],
          ),
          backgroundColor: Colors.teal,
          titleStyle: const TextStyle(color: Colors.white),
          middleTextStyle: const TextStyle(
            color: Colors.white,
          ),
          radius: 10,
          confirm: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shadowColor: Colors.tealAccent,
              textStyle: const TextStyle(
                fontSize: 18,
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              minimumSize: Size(120, 50),
            ),
            onPressed: () async {
              var isAuthenticated = await BiometricUtil().authenticate();
              if (isAuthenticated) {
                Get.back();
              }
            },
            child: const Text(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              'Biometric login',
            ),
          ),
        );
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
