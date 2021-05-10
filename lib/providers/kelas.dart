import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/models/Kelas.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class KelasProvider extends ChangeNotifier {
  final formatter = new DateFormat('yyyy-MM-dd');
  List<Kelas> _kelas = [];

  List<Kelas> get list {
    return [..._kelas];
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

  Future<void> registerClass({@required String token, @required int userId, @required String code}) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      "code": code,
      "user_id": userId,
    });

    try {
      final res = await http.post(
        'http://' + constant.API_URL + '/api/class/register-class',
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
}
