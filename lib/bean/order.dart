// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  List<Result> result;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
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

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        orderId: json["orderId"],
        personPhone: json["personPhone"] ?? '',
        personEmail: json["personEmail"] ?? '',
        personName: json["personName"] ?? '',
        personSex: json["personSex"] ?? '',
        personId: json["personId"] ?? '',
        password: json["password"] ?? '',
        roomId: json["roomId"] ?? '',
        startTime: DateTime.parse(json["startTime"] ?? ''),
        endTime: DateTime.parse(json["endTime"] ?? ''),
        orderPrice: json["orderPrice"] ?? '',
        createDate: DateTime.parse(json["createDate"] ?? ''),
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
