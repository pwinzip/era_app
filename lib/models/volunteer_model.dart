// To parse this JSON data, do
//
//     final volunteerModel = volunteerModelFromJson(jsonString);

import 'dart:convert';

VolunteerModel volunteerModelFromJson(String str) =>
    VolunteerModel.fromJson(json.decode(str));

String volunteerModelToJson(VolunteerModel data) => json.encode(data.toJson());

class VolunteerModel {
  int userId;
  int moo;
  String tambon;
  String amphoe;
  String prefix;
  String name;
  int userType;

  VolunteerModel({
    required this.userId,
    required this.moo,
    required this.tambon,
    required this.amphoe,
    required this.prefix,
    required this.name,
    required this.userType,
  });

  factory VolunteerModel.fromJson(Map<String, dynamic> json) => VolunteerModel(
        userId: json["user_id"],
        moo: json["moo"],
        tambon: json["tambon"],
        amphoe: json["amphoe"],
        prefix: json["prefix"],
        name: json["name"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "moo": moo,
        "tambon": tambon,
        "amphoe": amphoe,
        "prefix": prefix,
        "name": name,
        "user_type": userType,
      };
}
