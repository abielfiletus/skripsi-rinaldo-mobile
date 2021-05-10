import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skripsi_rinaldo/models/summary.dart';

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/models/dashboard.dart';

class DashboardProvider extends ChangeNotifier {
  Dashboard _dashboard;

  Dashboard get data {
    return _dashboard;
  }

  Future<void> getData({@required String token, String classId = '', @required String userId}) async {
    Summary summary;
    final params = {
      'class_id': classId,
      'user_id': userId,
    };

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/dashboard/summary', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];

      data.asMap().forEach((key, value) {
        summary = Summary(
          id: value['id'] != null ? value['id'].toString() : '',
          durasi: value['durasi'] != null ? ((double.parse(value['durasi']) / 3600).toStringAsFixed(3)).toString() : '',
          nilai: value['nilai'] != null ? value['nilai'].toString() : '-',
          status: value['status'] ?? '-',
        );
      });

      _dashboard = Dashboard(summary: summary);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
