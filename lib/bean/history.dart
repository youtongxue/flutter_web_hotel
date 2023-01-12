// To parse this JSON data, do
//
//     final history = historyFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  History({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  List<Result> result;

  factory History.fromJson(Map<String, dynamic> json) => History(
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
    required this.historyId,
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
    required this.appRaise,
    required this.appRaiseDate,
  });

  int historyId;
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
  dynamic appRaise;
  dynamic appRaiseDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        historyId: json["historyId"],
        orderId: json["orderId"],
        personPhone: json["personPhone"] ?? '',
        personEmail: json["personEmail"] ?? '',
        personName: json["personName"] ?? '',
        personSex: json["personSex"] ?? '',
        personId: json["personId"],
        password: json["password"],
        roomId: json["roomId"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        orderPrice: json["orderPrice"] ?? '',
        createDate: DateTime.parse(json["createDate"]),
        appRaise: json["appRaise"] ?? '',
        appRaiseDate: json["appRaiseDate"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "historyId": historyId,
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
        "appRaise": appRaise,
        "appRaiseDate": appRaiseDate,
      };
}
