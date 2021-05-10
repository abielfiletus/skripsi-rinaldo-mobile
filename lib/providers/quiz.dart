import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/models/soal.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class QuizProvider extends ChangeNotifier {
  List<Soal> _soal = [];

  List<Soal> get list {
    return [..._soal];
  }

  Future<void> getList({@required String token, @required String quizId}) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = 'http://' + constant.API_URL + '/api/class-quiz/random-quiz/$quizId';

    try {
      final res = await http.get(url, headers: headers);
      final Map<String, dynamic> data = json.decode(res.body)['data'];
      final List<Soal> loadedSoal = [];

      final List soal = data['soal'];

      soal.asMap().forEach((key, value) {
        loadedSoal.add(Soal(
          classQuizId: data['id'],
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

  Future<void> submitAnswer({
    @required String token,
    @required String classId,
    @required String userId,
    @required String classMateriId,
    @required String classQuizId,
    @required String durasi,
    @required List<Map<String, dynamic>> jawaban,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      "class_id": classId,
      "user_id": userId,
      "class_materi_id": classMateriId,
      "class_quiz_id": classQuizId,
      "durasi": durasi,
      "jawaban": jawaban,
    });

    try {
      final res = await http.post(
        'http://' + constant.API_URL + '/api/class-quiz/submit-quiz',
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal submit jawaban. Silakan coba lagi.');

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
