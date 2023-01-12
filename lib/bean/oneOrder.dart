// To parse this JSON data, do
//
//     final oneOrder = oneOrderFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OneOrder oneOrderFromJson(String str) => OneOrder.fromJson(json.decode(str));

String oneOrderToJson(OneOrder data) => json.encode(data.toJson());

class OneOrder {
  OneOrder({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  OneOrderResult result;

  factory OneOrder.fromJson(Map<String, dynamic> json) => OneOrder(
        code: json["code"],
        message: json["message"],
        result: OneOrderResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "result": result.toJson(),
      };
}

class OneOrderResult {
  OneOrderResult({
    required this.orderId,
    required this.personPhone,
    required this.personEmail,
    required this.personName,
    required this.personSex,
    required this.personId,
    required this.password,
    required this.roomId,
    required this.startTime,
    required this.endTime,
    required this.orderPrice,
    required this.createDate,
  });

  int orderId;
  String personPhone;
  String personEmail;
  String personName;
  String personSex;
  String personId;
  String password;
  int roomId;
  DateTime startTime;
  DateTime endTime;
  String orderPrice;
  DateTime createDate;

  factory OneOrderResult.fromJson(Map<String, dynamic> json) => OneOrderResult(
        orderId: json["orderId"],
        personPhone: json["personPhone"] ?? '',
        personEmail: json["personEmail"] ?? '',
        personName: json["personName"] ?? '',
        personSex: json["personSex"] ?? '',
        personId: json["personId"] ?? '',
        password: json["password"] ?? '',
        roomId: json["roomId"] ?? '',
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        orderPrice: json["orderPrice"] ?? '',
        createDate: DateTime.parse(json["createDate"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "personPhone": personPhone,
        "personEmail": personEmail,
        "personName": personName,
        "personSex": personSex,
        "personId": personId,
        "password": password,
        "roomId": roomId,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "orderPrice": orderPrice,
        "createDate": createDate.toIso8601String(),
      };
}
