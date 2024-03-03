// To parse this JSON data, do
//
//     final asselder = asselderFromJson(jsonString);

import 'dart:convert';

AsselderModel asselderFromJson(String str) =>
    AsselderModel.fromJson(json.decode(str));

String asselderToJson(AsselderModel data) => json.encode(data.toJson());

class AsselderModel {
  int userId;
  String prefix;
  String name;
  String codeName;
  String houseNo;
  int moo;
  String tambon;
  String amphoe;
  int? assId;
  int? assessorId;
  int? month;
  int? year;
  int? assPersonal;
  int? assPart1;
  int? assPart2;
  int? assPart3;
  int? assPart4;
  int? assPart5;
  int? assPart6;
  int? assPart7;
  int? assPart8;
  int? status;

  AsselderModel({
    required this.userId,
    required this.codeName,
    required this.houseNo,
    required this.moo,
    required this.tambon,
    required this.amphoe,
    // required this.volunteerId,
    required this.prefix,
    required this.name,
    required this.assId,
    required this.assessorId,
    required this.month,
    required this.year,
    required this.assPersonal,
    required this.assPart1,
    required this.assPart2,
    required this.assPart3,
    required this.assPart4,
    required this.assPart5,
    required this.assPart6,
    required this.assPart7,
    required this.assPart8,
    required this.status,
  });

  factory AsselderModel.fromJson(Map<String, dynamic> json) => AsselderModel(
        userId: json["id"],
        prefix: json["prefix"],
        name: json["name"],
        codeName: json["code_name"],
        houseNo: json["house_no"],
        moo: json["moo"],
        tambon: json["tambon"],
        amphoe: json["amphoe"],
        assId: json["ass_id"],
        assessorId: json["assessor_id"],
        month: json["month"],
        year: json["year"],
        assPersonal: json["ass_personal"],
        assPart1: json["ass_part1"],
        assPart2: json["ass_part2"],
        assPart3: json["ass_part3"],
        assPart4: json["ass_part4"],
        assPart5: json["ass_part5"],
        assPart6: json["ass_part6"],
        assPart7: json["ass_part7"],
        assPart8: json["ass_part8"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": userId,
        "code_name": codeName,
        "house_no": houseNo,
        "moo": moo,
        "tambon": tambon,
        "amphoe": amphoe,
        // "volunteer_id": volunteerId,
        "prefix": prefix,
        "name": name,
        "ass_id": assId,
        "assessor_id": assessorId,
        "month": month,
        "year": year,
        "ass_personal": assPersonal,
        "ass_part1": assPart1,
        "ass_part2": assPart2,
        "ass_part3": assPart3,
        "ass_part4": assPart4,
        "ass_part5": assPart5,
        "ass_part6": assPart6,
        "ass_part7": assPart7,
        "ass_part8": assPart8,
        "status": status,
      };
}
