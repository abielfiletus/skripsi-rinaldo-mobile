import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:skripsi_rinaldo/models/Kelas.dart';
import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class KelasProvider extends ChangeNotifier {
  final formatter = new DateFormat('yyyy-MM-dd');
  List<Kelas> _kelas = [];
  Kelas _detailKelas;

  List<Kelas> get list {
    return [..._kelas];
  }

  Kelas get detail {
    return _detailKelas;
  }

  Future<void> getList({@required String token, @required int userId}) async {
    final params = {
      'form[end]': DateFormat('yyyy-MM-dd').format(new DateTime.now()),
      'form[user_id]': userId.toString(),
    };

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/user-class', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];

      final List<Kelas> loadedKelas = [];

      data.asMap().forEach((key, value) {
        loadedKelas.add(
          Kelas(
            id: value['class']['id'],
            code: value['class']['code'],
            end: formatter.parse(value['class']['end']),
            name: value['class']['name'],
            start: formatter.parse(value['class']['start']),
          ),
        );
      });

      _kelas = loadedKelas;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> guruGetClass({@required String token, @required int userId}) async {
    final params = {'form[user_id]': userId.toString()};

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];

      final List<Kelas> loadedKelas = [];

      data.asMap().forEach((key, value) {
        loadedKelas.add(
          Kelas(
            id: value['id'],
            code: value['code'],
            end: formatter.parse(value['end']),
            name: value['name'],
            start: formatter.parse(value['start']),
            materiTotal: value['materi_total'],
            studentTotal: value['student_total'],
            nilaiMinimum: value['nilai_lulus'],
          ),
        );
      });

      _kelas = loadedKelas;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getDetailClass({@required String token, @required int id}) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class/$id');

    try {
      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body)['data'];

      if (data != null) {
        _detailKelas = Kelas(
          id: data['id'],
          code: data['code'],
          end: formatter.parse(data['end']),
          name: data['name'],
          start: formatter.parse(data['start']),
          nilaiMinimum: data['nilai_lulus'],
        );
      }

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> registerClass({@required String token, @required int userId, @required String code}) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      "code": code,
      "user_id": userId,
    });

    try {
      final res = await http.post(
        Uri.http(constant.API_URL, '/api/class/register-class'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Kode tidak ditemukan. Silahkan cek kembali kode Anda');

      final data = body['data'];

      _kelas = [
        Kelas(
          code: data['code'],
          end: formatter.parse(data['end']),
          id: data['id'],
          name: data['name'],
          start: formatter.parse(data['start']),
        )
      ];

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> create({
    @required String token,
    @required String name,
    @required String start,
    @required String end,
    @required String nilai,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      "name": name,
      "start": start,
      "end": end,
      "nilai_lulus": nilai,
    });

    try {
      final res = await http.post(
        Uri.http(constant.API_URL, '/api/class'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal membuat kelas. Silahkan coba kembali.');

      final data = body['data'];

      _kelas.add(Kelas(
        id: data['id'],
        code: data['code'],
        end: formatter.parse(data['end']),
        name: data['name'],
        start: formatter.parse(data['start']),
        materiTotal: '0',
        studentTotal: '0',
        nilaiMinimum: data['nilai_lulus'],
      ));

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> update({
    @required String token,
    @required int id,
    @required int idx,
    @required String name,
    @required String start,
    @required String end,
    @required String nilai,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      "name": name,
      "start": start,
      "end": end,
      "nilai_lulus": nilai,
    });

    try {
      final res = await http.put(
        Uri.http(constant.API_URL, '/api/class/$id'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal membuat kelas. Silahkan coba kembali.');

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> delete(String token, int id) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/class/$id');

    try {
      await http.delete(url, headers: headers);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
