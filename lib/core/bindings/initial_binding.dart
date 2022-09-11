import 'package:get/get.dart';

import 'authentication_binding.dart';
import 'cart_binding.dart';

// @see https://github.com/jonataslaw/getx/blob/master/documentation/en_US/dependency_management.md#getlazyput

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    AuthenticationBinding().dependencies();
    CartBinding().dependencies();
  }
}
