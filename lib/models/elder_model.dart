// To parse this JSON data, do
//
//     final elderModel = elderModelFromJson(jsonString);

import 'dart:convert';

ElderModel elderModelFromJson(String str) =>
    ElderModel.fromJson(json.decode(str));

String elderModelToJson(ElderModel data) => json.encode(data.toJson());

class ElderModel {
  int id;
  String prefix;
  String name;
  String codeName;
  String houseNo;
  int moo;
  String tambon;
  String amphoe;

  ElderModel({
    required this.id,
    required this.prefix,
    required this.name,
    required this.codeName,
    required this.houseNo,
    required this.moo,
    required this.tambon,
    required this.amphoe,
  });

  factory ElderModel.fromJson(Map<String, dynamic> json) => ElderModel(
        id: json["id"],
        prefix: json["prefix"],
        name: json["name"],
        codeName: json["code_name"],
        houseNo: json["house_no"],
        moo: json["moo"],
        tambon: json["tambon"],
        amphoe: json["amphoe"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prefix": prefix,
        "name": name,
        "code_name": codeName,
        "house_no": houseNo,
        "moo": moo,
        "tambon": tambon,
        "amphoe": amphoe,
      };
}
