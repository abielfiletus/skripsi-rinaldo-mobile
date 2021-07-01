import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/models/ortu.dart';

class OrtuProvider extends ChangeNotifier {
  List<Ortu> _ortu = [];

  List<Ortu> get list {
    return [..._ortu];
  }

  Future<void> getList(String token, int usulanMeetingId) async {
    final params = {'form[usulan_meeting_id]': usulanMeetingId.toString()};

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/user-chosen-meeting', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];
      print(data);
      final List<Ortu> loadedOrtu = [];

      data.asMap().forEach((key, value) {
        loadedOrtu.add(
          Ortu(
            id: value['id'],
            userId: value['user_id'],
            name: value['name'],
            avatar: value['avatar'],
            chosenDate: value['chosen_date'] != null ? DateTime.parse(value['chosen_date']) : null,
            studentName: value['student_name'],
          ),
        );
      });

      _ortu = loadedOrtu;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> delete(String token, int id) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/user-class/$id');

    try {
      await http.delete(url, headers: headers);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
