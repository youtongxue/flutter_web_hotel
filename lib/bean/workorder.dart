// To parse this JSON data, do
//
//     final workOrder = workOrderFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

WorkOrder workOrderFromJson(String str) => WorkOrder.fromJson(json.decode(str));

String workOrderToJson(WorkOrder data) => json.encode(data.toJson());

class WorkOrder {
  WorkOrder({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  List<Result> result;

  factory WorkOrder.fromJson(Map<String, dynamic> json) => WorkOrder(
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
    required this.workOrderId,
    required this.createTime,
    required this.orderId,
    required this.content,
    required this.state,
  });

  int workOrderId;
  DateTime createTime;
  int orderId;
  String content;
  String state;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        workOrderId: json["workOrderId"],
        createTime: DateTime.parse(json["createTime"]),
        orderId: json["orderId"],
        content: json["content"] ?? '',
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "workOrderId": workOrderId,
        "createTime": createTime.toIso8601String(),
        "orderId": orderId,
        "content": content,
        "state": state,
      };
}
