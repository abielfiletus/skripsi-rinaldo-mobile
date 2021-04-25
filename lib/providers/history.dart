import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/models/history.dart';

class HistoryProvider extends ChangeNotifier {
  List<History> _histories = [];

  List<History> get list {
    return [..._histories];
  }

  Future<void> getList({@required String token, String startDate = '', String endDate = ''}) async {
    final params = {
      'form[start_date]': startDate,
      'form[end_date]': endDate,
    };

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/history', params);

    try {
      // final res = await http.get(url, headers: headers);
      // final List data = json.decode(res.body)['result'];
      final List data = [
        {
          'id': 1,
          'class_id': 1,
          'class_materi_id': 1,
          'class_materi_name': 'Tes Nama Materi',
          'class_name': 'Tes Nama Kelas',
          'class_quiz_id': 1,
          'class_quiz_name': 'Tes Nama Quiz',
          'durasi': 30,
          'nilai': 100,
          'status': 'Lulus',
        },
      ];

      final List<History> loadedHistory = [];
      print(url);
      data.asMap().forEach((key, value) {
        loadedHistory.add(
          History(
            id: value['id'],
            classId: value['class_id'],
            classMateriID: value['class_materi_id'],
            classMateriName: value['class_materi_name'],
            className: value['class_name'],
            classQuizId: value['class_quiz_id'],
            classQuizName: value['class_quiz_name'],
            durasi: value['durasi'],
            nilai: value['nilai'],
            status: value['status'],
          ),
        );
      });

      _histories = loadedHistory;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
