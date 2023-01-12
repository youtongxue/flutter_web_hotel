// To parse this JSON data, do
//
//     final addAdmin = addAdminFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddAdmin addAdminFromJson(String str) => AddAdmin.fromJson(json.decode(str));

String addAdminToJson(AddAdmin data) => json.encode(data.toJson());

class AddAdmin {
  AddAdmin({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  AddAdminResult result;

  factory AddAdmin.fromJson(Map<String, dynamic> json) => AddAdmin(
        code: json["code"],
        message: json["message"],
        result: AddAdminResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "result": result.toJson(),
      };
}

class AddAdminResult {
  AddAdminResult({
    required this.adminId,
    required this.adminName,
    required this.password,
    required this.createDate,
  });

  int adminId;
  String adminName;
  String password;
  DateTime createDate;

  factory AddAdminResult.fromJson(Map<String, dynamic> json) => AddAdminResult(
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
