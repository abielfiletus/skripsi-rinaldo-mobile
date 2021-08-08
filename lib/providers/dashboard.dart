import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:skripsi_rinaldo/models/dashboard.dart';
import 'package:skripsi_rinaldo/models/dashboardMateri.dart';
import 'package:skripsi_rinaldo/models/kelas.dart';
import 'package:skripsi_rinaldo/models/materi.dart';
import 'package:skripsi_rinaldo/models/summary.dart';
import 'package:skripsi_rinaldo/models/usulanMeeting.dart';
import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;

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

  Future<void> getDataOrtu({@required String token, String nis = ''}) async {
    Summary summary;
    List<UsulanMeeting> meeting = [];
    final params = {'nis': nis};

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/dashboard/summary-orang-tua', params);

    try {
      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body)['data'];

      if (data != null) {
        if (data['murid'].length > 0) {
          summary = Summary(
            id: data['murid'][0]['id'] != null ? data['murid'][0]['id'].toString() : '',
            durasi: data['murid'][0]['durasi'] != null
                ? ((double.parse(data['murid'][0]['durasi']) / 3600).toStringAsFixed(3)).toString()
                : '',
            nilai: data['murid'][0]['nilai'] != null ? data['murid'][0]['nilai'].toString() : '-',
            status: data['murid'][0]['status'] ?? '-',
          );
        }

        if (data['meeting'].length > 0) {
          for (var item in data['meeting']) {
            meeting.add(
              UsulanMeeting(
                id: item['usulan_meeting_id'],
                classId: item['usulan_meeting']['class_id'],
                end: DateTime.parse(item['end_date']),
                link: item['link'],
                name: item['usulan_meeting']['name'],
                start: DateTime.parse(item['start_date']),
                description: item['usulan_meeting']['description'],
              ),
            );
          }
        }

        _dashboard = Dashboard(summary: summary, meeting: meeting);
      }
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> getDataGuru({@required String token, String userId = ''}) async {
    List<DashboardMateri> materi = [];
    List<UsulanMeeting> meeting = [];
    final params = {'user_id': userId, 'date': DateFormat('yyyy-MM-dd').format(DateTime.now())};

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/dashboard/summary-guru', params);

    try {
      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body)['data'];

      if (data['materi'].length > 0) {
        for (var materiItem in data['materi']) {
          List<Materi> tempMateri = [];
          for (var item in materiItem['materi'])
            tempMateri.add(Materi(id: item['id'], name: item['name'], path: item['path']));

          Kelas kelas = Kelas(
            id: materiItem['class']['id'],
            code: materiItem['class']['code'],
            end: DateTime.parse(materiItem['class']['end']),
            name: materiItem['class']['name'],
            start: DateTime.parse(materiItem['class']['start']),
          );
          materi.add(DashboardMateri(kelas: kelas, materi: tempMateri));
        }
      }

      if (data['meeting'].length > 0) {
        for (var item in data['meeting']) {
          meeting.add(
            UsulanMeeting(
              id: item['usulan_meeting_id'],
              classId: item['usulan_meeting']['class_id'],
              className: item['usulan_meeting']['class']['name'],
              end: DateTime.parse(item['end_date']),
              link: item['link'],
              name: item['usulan_meeting']['name'],
              start: DateTime.parse(item['start_date']),
              description: item['usulan_meeting']['description'],
            ),
          );
        }
      }

      _dashboard = Dashboard(materi: materi, meeting: meeting);
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
