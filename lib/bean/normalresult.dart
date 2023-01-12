// To parse this JSON data, do
//
//     final norMalResult = norMalResultFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

NorMalResult norMalResultFromJson(String str) =>
    NorMalResult.fromJson(json.decode(str));

String norMalResultToJson(NorMalResult data) => json.encode(data.toJson());

class NorMalResult {
  NorMalResult({
    required this.code,
    required this.message,
    required this.result,
  });

  String code;
  String message;
  String result;

  factory NorMalResult.fromJson(Map<String, dynamic> json) => NorMalResult(
        code: json["code"],
        message: json["message"],
        result: json["result"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "result": result,
      };
}
