import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/models/materi.dart';
import 'package:skripsi_rinaldo/models/quiz.dart';

class MateriProvider extends ChangeNotifier {
  List<Materi> _materi = [];

  List<Materi> get list {
    return [..._materi];
  }

  Future<void> getList({@required String token, String classId = '', @required String userId}) async {
    final params = {
      'form[class_id]': classId,
      'form[user_id]': userId,
    };

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class-materi', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];

      final List<Materi> loadedMateri = [];

      data.asMap().forEach((key, value) {
        loadedMateri.add(
          Materi(
            id: value['id'],
            classId: value['class_id'],
            className: value['class_name'],
            status: value['status'],
            name: value['name'],
            path: value['path'],
            tanggalKumpul: value['tanggal_kumpul'],
            historyId: value['history_id'] != null ? value['history_id'].toString() : '',
            quiz: Quiz(
              classMateriId: value['class_materi_id'],
              id: value['quiz_id'],
              name: value['quiz_name'],
              nilaiLulus: value['quiz_nilai_lulus'],
              totalSoal: value['quiz_total_soal'],
            ),
          ),
        );
      });

      _materi = loadedMateri;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
