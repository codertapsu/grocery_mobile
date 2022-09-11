import 'package:get/get.dart';
import 'product.model.dart';

class CartItemModel {
  CartItemModel({
    required ProductModel product,
    required int quantity,
  }) {
    this.product = product;
    this.quantity = quantity;
  }

  late final Rx<ProductModel> _product;
  set product(ProductModel value) => _product.value = value;
  ProductModel get product => _product.value;

  late final RxInt _quantity;
  set quantity(int value) => _quantity.value = value;
  int get quantity => _quantity.value;

  void incrementQuantity() {
    if (quantity >= 10) {
      quantity = 10;
    } else {
      quantity += 1;
    }
  }

  void decrementQuantity() {
    if (quantity <= 1) {
      quantity = 1;
    } else {
      quantity -= 1;
    }
  }
}
