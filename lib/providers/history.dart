import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/models/history.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class HistoryProvider extends ChangeNotifier {
  List<History> _histories = [];

  List<History> get list {
    return [..._histories];
  }

  Future<void> getList({
    @required String token,
    String userId,
    String startDate = '',
    String endDate = '',
    String classMateriId = '',
  }) async {
    final params = {
      'form[user_id]': userId,
      'form[start_date]': startDate,
      'form[end_date]': endDate,
      'form[class_materi_id]': classMateriId,
    };

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/user-class-history', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];

      final List<History> loadedHistory = [];

      data.asMap().forEach((key, value) {
        loadedHistory.add(
          History(
            id: value['id'],
            classMateriID: value['class_materi_id'],
            classMateriName: value['class_materi_name'],
            durasi: (value['durasi'] / 60).toStringAsFixed(2),
            nilai: value['nilai'],
            status: value['status'],
            userAvatar: value['avatar'],
            userName: value['name'],
          ),
        );
      });

      _histories = loadedHistory;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateHistory({
    @required String token,
    String classId = '',
    String userId,
    String classMateriId,
    String classQuizId,
    String durasi,
    String historyId,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final String jsonData = json.encode({
      'class_id': classId,
      'user_id': userId,
      'class_materi_id': classMateriId,
      'class_quiz_id': classQuizId != 'null' ? classQuizId : '',
      'durasi': durasi,
    });

    http.Response res;

    try {
      if (historyId != null) {
        res = await http.put(
          Uri.http(constant.API_URL, '/api/user-class-history/$historyId'),
          body: jsonData,
          headers: headers,
        );
      } else {
        res = await http.post(
          Uri.http(constant.API_URL, '/api/user-class-history'),
          body: jsonData,
          headers: headers,
        );
      }

      final bool status = json.decode(res.body)['status'];

      if (!status) throw HttpException('Gagal mengupdate history.');

      final data = json.decode(res.body)['data'];

      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
