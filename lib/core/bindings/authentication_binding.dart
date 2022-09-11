import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';

class AuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.put(
      AuthenticationController(),
      permanent: true,
      tag: (AuthenticationController).toString(),
    );
  }
}
