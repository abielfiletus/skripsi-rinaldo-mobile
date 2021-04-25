import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/models/soal.dart';

class QuizProvider extends ChangeNotifier {
  List<Soal> _soal = [];

  List<Soal> get list {
    return [..._soal];
  }

  Future<void> getList({@required String token, String classMateriId = '', String userId = ''}) async {
    final params = {
      'form[class_materi_id]': classMateriId,
    };

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/Quiz', params);

    try {
      // final res = await http.get(url, headers: headers);
      // final List data = json.decode(res.body)['result'];
      final List data = [
        {
          'clas_quiz_id': 1,
          'id': 1,
          'jawaban_a': 'Pilihan a',
          'jawaban_b': 'Pilihan b',
          'jawaban_c': 'Pilihan c',
          'jawaban_d': 'Pilihan d',
          'jawaban_e': 'Pilihan e',
          'soal': 'Tes Soal 1',
        },
      ];

      final List<Soal> loadedSoal = [];
      print(url);
      data.asMap().forEach((key, value) {
        loadedSoal.add(Soal(
          classQuizId: value['clas_quiz_id'],
          id: value['id'],
          jawabanA: value['jawaban_a'],
          jawabanB: value['jawaban_b'],
          jawabanC: value['jawaban_c'],
          jawabanD: value['jawaban_d'],
          jawabanE: value['jawaban_e'],
          soal: value['soal'],
        ));
      });

      _soal = loadedSoal;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
