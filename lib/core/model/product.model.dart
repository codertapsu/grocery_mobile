import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

class ProductModel extends Equatable {
  late final RxString _category;
  set category(String value) => _category.value = value;
  String get category => _category.value;

  late final RxString _description;
  set description(String value) => _description.value = value;
  String get description => _description.value;

  final RxnString _image = RxnString();
  set image(String value) => _image.value = value;
  String get image => _image.value ?? '';

  late final RxString _name;
  set name(String value) => _name.value = value;
  String get name => _name.value;

  late final RxDouble _price;
  set price(double value) => _price.value = value;
  double get price => _price.value;

  late final RxInt _id;
  set id(int value) => _id.value = value;
  int get id => _id.value;

  final RxBool _like = RxBool(false);
  set like(bool value) => _like.value = value;
  bool get like => _like.value;

  String get dollar {
    return 'U\$ ${price.toStringAsFixed(2)}';
  }

  ProductModel({
    required String category,
    required String description,
    required String name,
    required double price,
    required int id,
    bool like = false,
    String? image,
  }) {
    this.category = category;
    this.description = description;
    this.id = id;
    this.name = name;
    this.price = price;
    this.image = image!;
    this.like = like;
  }

  factory ProductModel.fromRawJson(String str) {
    return ProductModel.fromJson(json.decode(str));
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      category: json['category'],
      description: json['description'],
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      like: json['like'],
    );
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'description': description,
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'like': like,
    };
  }

  @override
  List<Object?> get props {
    return [
      category,
      description,
      id,
      name,
      price,
      image,
      like,
    ];
  }
}
