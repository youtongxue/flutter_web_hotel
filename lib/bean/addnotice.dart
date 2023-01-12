// To parse this JSON data, do
//
//     final addNotice = addNoticeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddNotice addNoticeFromJson(String str) => AddNotice.fromJson(json.decode(str));

String addNoticeToJson(AddNotice data) => json.encode(data.toJson());

class AddNotice {
  AddNotice({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  Result result;

  factory AddNotice.fromJson(Map<String, dynamic> json) => AddNotice(
        code: json["code"],
        message: json["message"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "result": result.toJson(),
      };
}

class Result {
  Result({
    required this.noticeId,
    required this.createTime,
    required this.content,
  });

  int noticeId;
  DateTime createTime;
  String content;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        noticeId: json["noticeId"],
        createTime: DateTime.parse(json["createTime"]),
        content: json["content"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "noticeId": noticeId,
        "createTime": createTime.toIso8601String(),
        "content": content,
      };
}
