part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const home = _Paths.home;
  static const product = _Paths.product;
  static const favorite = _Paths.favorite;
  static const settings = _Paths.settings;
  static const other = _Paths.other;
}

abstract class _Paths {
  static const home = '/';
  static const product = '/products/:id';
  static const favorite = '/favorite';
  static const settings = '/settings';
  static const other = '/other';
}
