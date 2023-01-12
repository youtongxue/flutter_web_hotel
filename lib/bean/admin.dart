// To parse this JSON data, do
//
//     final admin = adminFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Admin adminFromJson(String str) => Admin.fromJson(json.decode(str));

String adminToJson(Admin data) => json.encode(data.toJson());

class Admin {
  Admin({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  List<Result> result;

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        code: json["code"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.adminId,
    required this.adminName,
    required this.password,
    required this.createDate,
  });

  int adminId;
  String adminName;
  String password;
  DateTime createDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        adminId: json["adminId"],
        adminName: json["adminName"] ?? '',
        password: json["password"] ?? '',
        createDate: DateTime.parse(json["createDate"]),
      );

  Map<String, dynamic> toJson() => {
        "adminId": adminId,
        "adminName": adminName,
        "password": password,
        "createDate": createDate.toIso8601String(),
      };
}
