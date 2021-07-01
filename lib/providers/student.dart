import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/models/student.dart';

class StudentProvider extends ChangeNotifier {
  List<Student> _students = [];

  List<Student> get list {
    return [..._students];
  }

  Future<void> getList(String token, int classId) async {
    final params = {
      'form[class_id]': classId.toString(),
      'form[include_user]': 'true',
    };

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/user-class', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];
      print(url);
      final List<Student> loadedStudent = [];

      data.asMap().forEach((key, value) {
        loadedStudent.add(
          Student(
            id: value['user']['id'],
            name: value['user']['name'],
            avatar: value['user']['avatar'],
            email: value['user']['email'],
            userClassId: value['id'],
          ),
        );
      });

      _students = loadedStudent;
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
