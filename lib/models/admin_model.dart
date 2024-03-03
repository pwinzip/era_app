// To parse this JSON data, do
//
//     final adminModel = adminModelFromJson(jsonString);

import 'dart:convert';

AdminModel adminModelFromJson(String str) =>
    AdminModel.fromJson(json.decode(str));

String adminModelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {
  int id;
  int userType;
  String userprefix;
  String name;
  String username;

  AdminModel({
    required this.id,
    required this.userType,
    required this.userprefix,
    required this.name,
    required this.username,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        id: json["id"],
        userType: json["user_type"],
        userprefix: json["prefix"],
        name: json["name"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_type": userType,
        "prefix": userprefix,
        "name": name,
        "username": username,
      };
}
