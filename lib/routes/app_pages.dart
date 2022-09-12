import 'package:get/get.dart';
import 'package:grocery_mobile/presentation/bindings/product_binding.dart';

import '../core/middlewares/auth_middleware.dart';
import '../presentation/bindings/home_bingding.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/product/product_page.dart';

// import '/app/modules/favorite/bindings/favorite_binding.dart';
// import '/app/modules/favorite/views/favorite_view.dart';
// import '/app/modules/home/bindings/home_binding.dart';
// import '/app/modules/home/views/home_view.dart';
// import '/app/modules/main/bindings/main_binding.dart';
// import '/app/modules/main/views/main_view.dart';
// import '/app/modules/other/bindings/other_binding.dart';
// import '/app/modules/other/views/other_view.dart';
// import '/app/modules/project_details/bindings/project_details_binding.dart';
// import '/app/modules/project_details/views/project_details_view.dart';
// import '/app/modules/settings/bindings/settings_binding.dart';
// import '/app/modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => HomePage(),
      binding: HomeBinding(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
      middlewares: [
        /// AuthMiddleware()
      ],
    ),
    GetPage(
      name: _Paths.product,
      page: () => const ProductPage(),
      binding: ProductBinding(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
    ),
    // GetPage(
    //   name: _Paths.FAVORITE,
    //   page: () => FavoriteView(),
    //   binding: FavoriteBinding(),
    //   preventDuplicates: true,
    //   transition: Transition.fadeIn,
    // ),
    // GetPage(
    //   name: _Paths.SETTINGS,
    //   page: () => SettingsView(),
    //   binding: SettingsBinding(),
    //   preventDuplicates: true,
    //   transition: Transition.fadeIn,
    // ),
    // GetPage(
    //   name: _Paths.OTHER,
    //   page: () => OtherView(),
    //   binding: OtherBinding(),
    //   preventDuplicates: true,
    //   transition: Transition.fadeIn,
    // ),
    // GetPage(
    //   name: _Paths.PROJECT_DETAILS,
    //   page: () => ProjectDetailsView(),
    //   binding: ProjectDetailsBinding(),
    //   preventDuplicates: true,
    //   transition: Transition.fadeIn,
    // ),
  ];
}
