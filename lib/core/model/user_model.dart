import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  String email;
  String id;
  String? name;
  String username;

  UserModel({
    required this.email,
    required this.id,
    required this.username,
    this.name,
  });

  factory UserModel.fromRawJson(String str) {
    return UserModel.fromJson(json.decode(str));
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      id: json['id'],
      name: json['name'],
      username: json['username'],
    );
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'id': id,
      'name': name,
      'username': username,
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      username,
    ];
  }
}
