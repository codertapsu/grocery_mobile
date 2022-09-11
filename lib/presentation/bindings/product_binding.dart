import 'package:get/get.dart';

import '../controllers/product_controller.dart';

class ProductBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
