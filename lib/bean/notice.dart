// To parse this JSON data, do
//
//     final notice = noticeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Notice noticeFromJson(String str) => Notice.fromJson(json.decode(str));

String noticeToJson(Notice data) => json.encode(data.toJson());

class Notice {
  Notice({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  List<NoticeResult> result;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        code: json["code"],
        message: json["message"],
        result: List<NoticeResult>.from(
            json["result"].map((x) => NoticeResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class NoticeResult {
  NoticeResult({
    required this.noticeId,
    required this.createTime,
    required this.content,
  });

  int noticeId;
  DateTime createTime;
  String content;

  factory NoticeResult.fromJson(Map<String, dynamic> json) => NoticeResult(
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
