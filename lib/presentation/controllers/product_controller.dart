import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../../core/config/config.dart';
import '../../core/controllers/cart_controller.dart';
import '../../core/http/http_client.dart';
import '../../core/model/cart_item.model.dart';
import '../../core/model/product.model.dart';

class ProductController extends GetxController with StateMixin<ProductModel> {
  final _logger = AppConfig.instance.logger;
  final _cartController = Get.find<CartController>();
  late final HttpClient _httpClient;

  ProductModel get product => state!;

  @override
  void onInit() {
    _httpClient = HttpClient();
    _loadProduct().then((_) {
      super.onInit();
    });
  }

  void addProduct() {
    try {
      CartItemModel? cartItem =
          (_cartController.value ?? []).firstWhereOrNull((cartItem) {
        return cartItem.product.id == product.id;
      });
      cartItem!.incrementQuantity();
    } catch (error) {
      _cartController.state!.add(CartItemModel(
        product: product,
        quantity: 1,
      ));
    }
    Get.back();
  }

  _loadProduct() async {
    try {
      // Get.toNamed("/products/${this.product.id.toString()}")
      var productId = Get.parameters['id'].toString();
      var response = await _httpClient.get('/products/$productId');
      change(
        ProductModel.fromJson(response.data),
        status: RxStatus.success(),
      );
    } catch (error) {
      _logger.e(error.toString());
      change(
        null,
        status: RxStatus.error('Error get data'),
      );
    }
  }
}
