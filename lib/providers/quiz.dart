import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skripsi_rinaldo/models/quiz.dart';
import 'package:skripsi_rinaldo/models/soal.dart';
import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class QuizProvider extends ChangeNotifier {
  List<Soal> _soal = [];
  Quiz _detail;
  Soal _detailSoal;

  List<Soal> get list {
    return [..._soal];
  }

  Quiz get detail {
    return _detail;
  }

  Soal get detailSoal {
    return _detailSoal;
  }

  Future<void> getList({@required String token, @required String quizId}) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    try {
      final res = await http.get(
        Uri.http(constant.API_URL, '/api/class-quiz/random-quiz/$quizId'),
        headers: headers,
      );

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

  Future<void> getGuruList({@required String token, @required String quizId}) async {
    final params = {
      'form[class_quiz_id]': quizId,
    };

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class-quiz', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];

      final List<Soal> loadedSoal = [];

      data.asMap().forEach((key, value) {
        loadedSoal.add(Soal(
          classQuizId: value['class_quiz_id'],
          id: value['id'],
          jawabanA: value['jawaban_a'],
          jawabanB: value['jawaban_b'],
          jawabanC: value['jawaban_c'],
          jawabanD: value['jawaban_d'],
          jawabanE: value['jawaban_e'],
          jawabanBenar: value['jawaban_benar'],
          soal: value['soal'],
        ));
      });

      _soal = loadedSoal;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getDetailQuiz(String token, int id) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class-quiz/$id');

    try {
      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body)['data'];

      if (data != null) {
        _detail = Quiz(
          classMateriId: data['class_materi_id'],
          id: data['id'],
          name: data['name'],
          nilaiLulus: data['nilai_lulus'],
          tanggalKumpul: data['tanggal_kumpul'],
        );
      }

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getDetailSoal(String token, int id) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class-quiz/detail-quiz/$id');

    try {
      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body)['data'];

      if (data != null) {
        _detailSoal = Soal(
          classQuizId: data['class_quiz_id'],
          id: data['id'],
          jawabanA: data['jawaban_a'],
          jawabanB: data['jawaban_b'],
          jawabanC: data['jawaban_c'],
          jawabanD: data['jawaban_d'],
          jawabanE: data['jawaban_e'],
          jawabanBenar: data['jawaban_benar'],
          soal: data['soal'],
        );
      }

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
        Uri.http(constant.API_URL, '/api/class-quiz/submit-quiz'),
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

  Future<void> createQuiz({
    @required String token,
    @required String name,
    @required String nilaiLulus,
    @required int classMateriId,
    @required String tanggalKumpul,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      'name': name,
      'nilai_lulus': nilaiLulus,
      'class_materi_id': classMateriId,
      'tanggal_kumpul': tanggalKumpul,
    });

    try {
      final res = await http.post(
        Uri.http(constant.API_URL, '/api/class-quiz'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal membuat quiz. Silakan coba lagi.');

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateQuiz({
    @required String token,
    @required int id,
    @required String name,
    @required String nilaiLulus,
    @required int classMateriId,
    @required String tanggalKumpul,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      'name': name,
      'nilai_lulus': nilaiLulus,
      'class_materi_id': classMateriId,
      'tanggal_kumpul': tanggalKumpul,
    });

    try {
      final res = await http.put(
        Uri.http(constant.API_URL, '/api/class-quiz/$id'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal mengubah quiz. Silakan coba lagi.');

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> delete(String token, int id) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class-quiz/$id');

    try {
      await http.delete(url, headers: headers);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> createSoal({
    @required String token,
    @required String soal,
    @required String jawabanA,
    @required String jawabanB,
    @required String jawabanC,
    @required String jawabanD,
    @required String jawabanE,
    @required String jawabanBenar,
    @required int classQuizId,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      'class_quiz_id': classQuizId,
      'soal': soal,
      'jawaban_a': jawabanA,
      'jawaban_b': jawabanB,
      'jawaban_c': jawabanC,
      'jawaban_d': jawabanD,
      'jawaban_e': jawabanE,
      'jawaban_benar': jawabanBenar,
    });

    try {
      final res = await http.post(
        Uri.http(constant.API_URL, '/api/class-quiz/detail-quiz'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal membuat soal. Silakan coba lagi.');

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateSoal({
    @required String token,
    @required int id,
    @required String soal,
    @required String jawabanA,
    @required String jawabanB,
    @required String jawabanC,
    @required String jawabanD,
    @required String jawabanE,
    @required String jawabanBenar,
    @required int classQuizId,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      'class_quiz_id': classQuizId,
      'soal': soal,
      'jawaban_a': jawabanA,
      'jawaban_b': jawabanB,
      'jawaban_c': jawabanC,
      'jawaban_d': jawabanD,
      'jawaban_e': jawabanE,
      'jawaban_benar': jawabanBenar,
    });

    try {
      final res = await http.put(
        Uri.http(constant.API_URL, '/api/class-quiz/detail-quiz/$id'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal mengubah quiz. Silakan coba lagi.');

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> deleteSoal(String token, int id) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class-quiz/quiz-detail/$id');

    try {
      await http.delete(url, headers: headers);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
