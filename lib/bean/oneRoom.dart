// To parse this JSON data, do
//
//     final oneRoom = oneRoomFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OneRoom oneRoomFromJson(String str) => OneRoom.fromJson(json.decode(str));

String oneRoomToJson(OneRoom data) => json.encode(data.toJson());

class OneRoom {
  OneRoom({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  OneRoomResult result;

  factory OneRoom.fromJson(Map<String, dynamic> json) => OneRoom(
        code: json["code"],
        message: json["message"],
        result: OneRoomResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "result": result.toJson(),
      };
}

class OneRoomResult {
  OneRoomResult({
    required this.roomId,
    required this.state,
    required this.price,
    required this.orderId,
  });

  int roomId;
  String state;
  String price;
  String orderId;

  factory OneRoomResult.fromJson(Map<String, dynamic> json) => OneRoomResult(
        roomId: json["roomId"],
        state: json["state"] ?? '',
        price: json["price"] ?? '',
        orderId: json["orderId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "roomId": roomId,
        "state": state,
        "price": price,
        "orderId": orderId,
      };
}
