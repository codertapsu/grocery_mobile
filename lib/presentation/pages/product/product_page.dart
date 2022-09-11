import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../controllers/product_controller.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 25),
              margin: EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.LIGHT,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Obx(
                    () => Text(
                      controller.state?.name ?? "",
                      style: TextStyle(
                        fontSize: 32,
                        color: AppColors.DARK,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Obx(
                    () => Text(
                      controller.state?.description ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.DARK,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    controller.product.dollar,
                    style: TextStyle(
                      fontSize: 32,
                      color: AppColors.LIGHT_GREEN,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    child: Text('ADD TO CART'),
                    onPressed: controller.addProduct,
                  ),
                  // child: OrganicButton(
                  //   controller.addProduct,
                  //   "ADD TO CART",
                  //   Feather.shopping_cart,
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
