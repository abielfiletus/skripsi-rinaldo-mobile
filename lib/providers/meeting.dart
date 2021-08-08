import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skripsi_rinaldo/models/meeting.dart';
import 'package:skripsi_rinaldo/models/usulanMeeting.dart';
import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class MeetingProvider extends ChangeNotifier {
  List<Meeting> _meeting = [];
  List<UsulanMeeting> _usulanMeeting = [];
  List<UsulanMeeting> _meetings = [];

  List<Meeting> get list {
    return [..._meeting];
  }

  List<UsulanMeeting> get listUsulan {
    return [..._usulanMeeting];
  }

  List<UsulanMeeting> get listMeeting {
    return [..._meetings];
  }

  Meeting detail(int idx) {
    return _meeting[idx];
  }

  Future<void> getList({@required String token, @required String userId, String classId}) async {
    final params = {
      'form[class_id]': classId,
      'form[user_id]': userId,
    };

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/usulan-meeting', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];

      final List<Meeting> loadedMeeting = [];
      data.asMap().forEach((key, value) {
        loadedMeeting.add(
          Meeting(
            choose: int.parse(value['choose']),
            className: value['class_name'],
            description: value['description'],
            endDate: DateTime.parse(value['end_date']),
            id: value['id'],
            name: value['name'],
            notChoose: int.parse(value['not_choose']),
            startDate: DateTime.parse(value['start_date']),
            classId: value['class_id'],
          ),
        );
      });

      _meeting = loadedMeeting;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getListUsulan({@required String token, @required String userId, String classId}) async {
    final params = {'user_id': userId};

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/usulan-meeting/no-meeting', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];

      final List<UsulanMeeting> loadedUsulanMeeting = [];
      data.asMap().forEach((key, value) {
        loadedUsulanMeeting.add(
          UsulanMeeting(
            classId: value['class_id'],
            className: value['class_name'],
            end: DateTime.parse(value['end_date']),
            start: DateTime.parse(value['start_date']),
            id: value['id'],
            name: value['name'],
          ),
        );
      });

      _usulanMeeting = loadedUsulanMeeting;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getListMeeting({@required String token, String userId, String nis}) async {
    final params = {'form[nis]': nis, 'form[user_id]': userId};

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, nis != null ? 'api/meeting/orang-tua' : 'api/meeting', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];

      final List<UsulanMeeting> loadedUsulanMeeting = [];
      data.asMap().forEach((key, value) {
        loadedUsulanMeeting.add(
          UsulanMeeting(
            classId: value['usulan_meeting']['class']['id'],
            className: value['usulan_meeting']['class']['name'],
            end: DateTime.parse(value['end_date']),
            start: DateTime.parse(value['start_date']),
            id: value['usulan_meeting_id'],
            name: value['usulan_meeting']['name'],
            link: value['link'],
          ),
        );
      });

      _meetings = loadedUsulanMeeting;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getListOrtuUsulan({@required String token, @required String nis}) async {
    final params = {'form[nis]': nis};

    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/user-chosen-meeting/orang-tua', params);

    try {
      final res = await http.get(url, headers: headers);
      final List data = json.decode(res.body)['data'];

      final List<Meeting> loadedMeeting = [];
      data.asMap().forEach((key, value) {
        loadedMeeting.add(
          Meeting(
            classId: value['usulan_meeting']['class']['id'],
            className: value['usulan_meeting']['class']['name'],
            endDate: DateTime.parse(value['usulan_meeting']['end_date']),
            startDate: DateTime.parse(value['usulan_meeting']['start_date']),
            id: value['usulan_meeting']['id'],
            name: value['usulan_meeting']['name'],
            description: value['usulan_meeting']['description'],
          ),
        );
      });

      _meeting = loadedMeeting;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> create({
    @required String token,
    @required String name,
    @required int classId,
    @required String start,
    @required String end,
    @required String description,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      "name": name,
      "start_date": start,
      "end_date": end,
      "description": description,
      "class_id": classId,
    });

    try {
      final res = await http.post(
        Uri.http(constant.API_URL, '/api/usulan-meeting'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);
      print(body);
      final bool status = body['status'];
      if (!status) throw HttpException('Gagal membuat usulan meeting. Silahkan coba kembali.');

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> update({
    @required String token,
    @required String name,
    @required int id,
    @required int idx,
    @required int classId,
    @required String start,
    @required String end,
    @required String description,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      "name": name,
      "start_date": start,
      "end_date": end,
      "description": description,
      "class_id": classId,
    });

    try {
      final res = await http.post(
        Uri.http(constant.API_URL, '/api/usulan-meeting'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal membuat usulan meeting. Silahkan coba kembali.');

      final data = body['data'];

      _meeting[idx] = Meeting(
        choose: data['choose'],
        className: data['class_name'],
        description: data['description'],
        endDate: DateTime.parse(data['end_date']),
        id: data['id'],
        name: data['name'],
        notChoose: data['not_choose'],
        startDate: DateTime.parse(data['start_date']),
      );

      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> delete(String token, int id) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.http(constant.API_URL, 'api/usulan-meeting/$id');

    try {
      await http.delete(url, headers: headers);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> createMeeting({
    @required String token,
    @required String link,
    @required int usulanMeetingId,
    @required String start,
    @required String end,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      "link_meeting": link,
      "start_date": start,
      "end_date": end,
      "usulan_meeting_id": usulanMeetingId,
    });

    try {
      final res = await http.post(
        Uri.http(constant.API_URL, '/api/meeting'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal membuat meeting. Silahkan coba kembali.');

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateMeeting({
    @required String token,
    @required int id,
    @required int idx,
    @required String link,
    @required int usulanMeetingId,
    @required String start,
    @required String end,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      "link_meeting": link,
      "start_date": start,
      "end_date": end,
      "usulan_meeting_id": usulanMeetingId,
    });

    try {
      final res = await http.post(
        Uri.http(constant.API_URL, '/api/meeting'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal membuat meeting. Silahkan coba kembali.');

      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> createUsulanMeetingOrtu({
    @required String token,
    @required int usulanMeetingId,
    @required int userId,
    @required String date,
  }) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    final String jsonData = json.encode({
      "usulan_meeting_id": usulanMeetingId,
      "user_id": userId,
      "chosen_date": date,
    });

    try {
      final res = await http.post(
        Uri.http(constant.API_URL, '/api/user-chosen-meeting/register-usulan'),
        body: jsonData,
        headers: headers,
      );

      final body = json.decode(res.body);

      final bool status = body['status'];
      if (!status) throw HttpException('Gagal membuat meeting. Silahkan coba kembali.');

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
