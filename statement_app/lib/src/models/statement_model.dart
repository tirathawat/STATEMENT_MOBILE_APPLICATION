// To parse this JSON data, do
//
//     final statementModel = statementModelFromJson(jsonString);

import 'dart:convert';

List<StatementModel> statementModelFromJson(String str) =>
    List<StatementModel>.from(
        json.decode(str).map((x) => StatementModel.fromJson(x)));

String statementModelToJson(List<StatementModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatementModel {
  StatementModel({
    this.id,
    this.date,
    this.amount,
    this.detail,
  });

  String id;
  String date;
  int amount;
  String detail;

  factory StatementModel.fromJson(Map<String, dynamic> json) => StatementModel(
        id: json["id"],
        date: json["date"],
        amount: json["amount"],
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "amount": amount,
        "detail": detail,
      };
}
