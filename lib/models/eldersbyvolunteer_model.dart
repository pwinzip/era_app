// To parse this JSON data, do
//
//     final eldersbyvolunteer = eldersbyvolunteerFromJson(jsonString);

import 'dart:convert';

EldersbyvolunteerModel eldersbyvolunteerFromJson(String str) =>
    EldersbyvolunteerModel.fromJson(json.decode(str));

String eldersbyvolunteerToJson(EldersbyvolunteerModel data) =>
    json.encode(data.toJson());

class EldersbyvolunteerModel {
  List<AssComplete> incomplete;
  List<AssComplete> complete;

  EldersbyvolunteerModel({
    required this.incomplete,
    required this.complete,
  });

  factory EldersbyvolunteerModel.fromJson(Map<String, dynamic> json) =>
      EldersbyvolunteerModel(
        incomplete: List<AssComplete>.from(
            json["incomplete"].map((x) => AssComplete.fromJson(x))),
        complete: List<AssComplete>.from(
            json["complete"].map((x) => AssComplete.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "incomplete": List<dynamic>.from(incomplete.map((x) => x.toJson())),
        "complete": List<dynamic>.from(complete.map((x) => x.toJson())),
      };
}

class AssComplete {
  int userId;
  String prefix;
  String name;
  String codeName;
  String houseNo;
  int moo;
  String tambon;
  String amphoe;

  AssComplete({
    required this.userId,
    required this.prefix,
    required this.name,
    required this.codeName,
    required this.houseNo,
    required this.moo,
    required this.tambon,
    required this.amphoe,
  });

  factory AssComplete.fromJson(Map<String, dynamic> json) => AssComplete(
        userId: json["id"],
        prefix: json["prefix"],
        name: json["name"],
        codeName: json["code_name"],
        houseNo: json["house_no"],
        moo: json["moo"],
        tambon: json["tambon"],
        amphoe: json["amphoe"],
      );

  Map<String, dynamic> toJson() => {
        "id": userId,
        "prefix": prefix,
        "name": name,
        "code_name": codeName,
        "house_no": houseNo,
        "moo": moo,
        "tambon": tambon,
        "amphoe": amphoe,
      };
}
