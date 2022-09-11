import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

class CategoryModel extends Equatable {
  late final RxString _key;
  set key(String value) => _key.value = value;
  String get key => _key.value;

  late final RxString _name;
  set name(String value) => _name.value = value;
  String get name => _name.value;

  late final RxString _color;
  set color(String value) => _color.value = value;
  String get color => _color.value;

  CategoryModel({
    required String key,
    required String name,
    required String color,
  }) {
    this.key = key;
    this.name = name;
    this.color = color;
  }

  @override
  List<Object?> get props {
    return [
      name,
      key,
      color,
    ];
  }
}
