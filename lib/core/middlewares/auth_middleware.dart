import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthenticationController _auth = Get.find<AuthenticationController>(
    tag: (AuthenticationController).toString(),
  );

  @override
  RouteSettings? redirect(String? route) {
    print('Is authed: ${_auth.authed.value}');
    return _auth.authed.value ? null : const RouteSettings(name: '/login');
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    if (!_auth.authed.value) {
      bindings = <Bindings>[];
    }
    return super.onBindingsStart(bindings);
  }

  @override
  Widget onPageBuilt(Widget page) {
    print(page.runtimeType);
    return page;
  }
}
