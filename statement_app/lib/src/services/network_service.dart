import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:statement_app/src/constants/api_constant.dart';
import 'package:statement_app/src/models/statement_model.dart';

class NetworkService {
  NetworkService._internal();

  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;

  static final _dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(onRequest: (options) async {
        options.baseUrl = API.BASE_URL;
        options.connectTimeout = 5000;
        options.receiveTimeout = 3000;
        return options;
      }, onResponse: (response) async {
        return response;
      }, onError: (e) async {
        return 'Network failed';
      }),
    );

  Future<List<StatementModel>> getStatement() async {
    final url = API.READ;
    final Response response = await _dio.get(url);
    if (response.statusCode == 200) {
      return statementModelFromJson(jsonEncode(response.data));
    }
    throw Exception('Network failed');
  }

  Future<String> createStatement(StatementModel statement) async {
    final url = API.CREATE;

    Map<String, dynamic> data = {
      'date': statement.date,
      'amount': statement.amount,
      'detail': statement.detail,
    };

    // FormData data = FormData.fromMap({
    //   'date': statement.date,
    //   'amount': statement.amount,
    //   'detail': statement.detail,
    // });
    await _dio.post(url, data: data);
    return 'Create Success';
  }

  Future<String> updateStatement(StatementModel statement) async {
    final url = "${API.UPDATE}/${statement.id}";

    // FormData data = FormData.fromMap({
    //   'date': statement.date,
    //   'amount': statement.amount,
    //   'detail': statement.detail,
    // });
    Map<String, dynamic> data = {
      'date': statement.date,
      'amount': statement.amount,
      'detail': statement.detail,
    };
    await _dio.put(url, data: data);
    return 'Update Success';
  }

  Future<String> deleteStatement(String statementID) async {
    final url = "${API.DELETE}/$statementID";
    await _dio.delete(url);
    return 'Delete Success';
  }
}
