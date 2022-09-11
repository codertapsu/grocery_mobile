import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../core/controllers/authentication_controller.dart';
import '../../core/http/http_client.dart';
import '../../core/model/user_model.dart';

class HomeController extends GetxController {
  final AuthenticationController _authenticationController =
      Get.find<AuthenticationController>(
    tag: (AuthenticationController).toString(),
  );

  get counter => _authenticationController.counter1;
}
