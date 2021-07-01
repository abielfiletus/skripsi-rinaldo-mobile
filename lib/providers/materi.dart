import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/models/materi.dart';
import 'package:skripsi_rinaldo/models/quiz.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class MateriProvider extends ChangeNotifier {
  List<Materi> _materi = [];

  List<Materi> get list {
    return [..._materi];
  }

  Materi detail(int idx) {
    return _materi[idx];
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

  Future<void> guruGetList({@required String token, String classId = ''}) async {
    final params = {
      'form[class_id]': classId,
    };

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class-materi/teacher', params);

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
            name: value['name'],
            path: value['path'],
            tanggalKumpul: value['tanggal_kumpul'],
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

  Future<void> create({
    @required String token,
    @required String name,
    @required int classId,
    @required String className,
    @required String materi,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final Map<String, String> jsonData = {'name': name, 'class_id': classId.toString()};

    final url = Uri.http(constant.API_URL, '/api/class-materi');
    final req = http.MultipartRequest('POST', url);

    req.headers.addAll(headers);
    req.fields.addAll(jsonData);

    req.files.add(await http.MultipartFile.fromPath('materi', materi));

    try {
      final res = await http.Response.fromStream(await req.send());

      final bool status = res.statusCode == 201 ? true : false;
      if (!status) throw HttpException('Gagal membuat materi, silahkan coba kembali.');

      final data = json.decode(res.body)['data'];

      _materi.add(Materi(
        id: data['id'],
        classId: classId,
        className: className,
        name: data['name'],
        path: data['path'],
      ));
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> update({
    @required String token,
    @required String name,
    @required int id,
    @required int classId,
    @required int idx,
    @required String className,
    @required String materi,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final Map<String, String> jsonData = {'name': name, 'class_id': classId.toString()};

    final url = Uri.http(constant.API_URL, '/api/class-materi/$id');
    final req = http.MultipartRequest('PUT', url);

    req.headers.addAll(headers);
    req.fields.addAll(jsonData);

    req.files.add(await http.MultipartFile.fromPath('materi', materi));

    try {
      final res = await http.Response.fromStream(await req.send());

      final bool status = res.statusCode == 200 ? true : false;
      if (!status) throw HttpException('Gagal mengubah materi, silahkan coba kembali.');

      final data = json.decode(res.body)['data'];

      _materi[idx] = Materi(
        id: id,
        classId: classId,
        className: className,
        name: data['name'],
        path: data['path'],
      );

      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> delete(String token, int id) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class-materi/$id');

    try {
      await http.delete(url, headers: headers);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
