import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../model/cart_item.model.dart';
import '../theme/app_colors.dart';
import '../theme/colors.dart';

class CartController extends GetxController
    with StateMixin<List<CartItemModel>> {
  List<CartItemModel> get cartItems => state!;

  String get total {
    double fold = (state ?? []).fold(0, (subtotal, cartItem) {
      return subtotal + cartItem.product.price * cartItem.quantity;
    });
    return 'U\$${fold.toStringAsFixed(2)}';
  }

  void deleteItem(CartItemModel cartItemModel) {
    (state ?? []).removeWhere((cartItem) {
      return cartItem.product.id == cartItemModel.product.id;
    });
  }

  placeOrder() {
    state!.clear();
    Get.back();
    Get.snackbar(
      'Placed',
      'Order placed with success!',
      // backgroundColor: ThemeColors.appBarColor,
      // colorText: ThemeColors.appBarColor,
      padding: const EdgeInsets.all(15),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(25),
      icon: const Icon(
        Feather.check,
        color: ThemeColors.primaryColor,
        size: 21,
      ),
    );
  }
}
