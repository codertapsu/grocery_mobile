import 'package:get/get.dart';
import 'package:grocery_mobile/core/controllers/local_storage_controller.dart';

import 'authentication_binding.dart';
import 'cart_binding.dart';
import 'settings_binding.dart';
import 'wallet_binding.dart';

// @see https://github.com/jonataslaw/getx/blob/master/documentation/en_US/dependency_management.md#getlazyput

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    AuthenticationBinding().dependencies();
    CartBinding().dependencies();
    SettingsBinding().dependencies();
    WalletBinding().dependencies();
    Get.put<LocalStorageController>(
      LocalStorageController(),
      permanent: true,
    );
  }
}
