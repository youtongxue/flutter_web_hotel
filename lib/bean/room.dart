// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'dart:convert';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room {
  Room({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  List<Result> result;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
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
    required this.roomId,
    required this.state,
    required this.price,
    required this.orderId,
  });

  int roomId;
  String state;
  String price;
  String orderId;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        roomId: json["roomId"],
        state: json["state"] ?? '',
        price: json["price"],
        orderId: json["orderId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "roomId": roomId,
        "state": state,
        "price": price,
        "orderId": orderId,
      };
}
