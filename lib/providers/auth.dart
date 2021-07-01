import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;
import 'package:skripsi_rinaldo/utils/HttpException.dart';
import 'package:skripsi_rinaldo/models/user.dart';

class AuthProvider with ChangeNotifier {
  final formatter = new DateFormat('yyyy-MM-dd');
  User _userdata;

  bool get isAuth {
    return _userdata != null;
  }

  User get user {
    return _userdata;
  }

  Future<void> login(String email, String pass) async {
    const Map<String, String> headers = {"Content-type": "application/json"};
    final String jsonData = json.encode({
      "email": email.trim(),
      "password": pass,
    });

    Uri url = Uri.http(constant.API_URL, '/api/auth/login');

    try {
      final res = await http.post(url, body: jsonData, headers: headers);

      final bool status = json.decode(res.body)['status'];
      if (!status) throw HttpException('Kombinasi email dan password tidak sesuai.');

      final data = json.decode(res.body)['data'];

      _userdata = User(
        email: data['email'],
        token: data['token'],
        id: data['id'],
        tanggalLahir: formatter.parse(data['tanggal_lahir']),
        name: data['name'],
        nis: data['nis'],
        roleId: data['role.id'],
        roleName: data['role.name'],
        jenisKelamin: data['jenis_kelamin'] == 'L' ? constant.JenisKelamin.laki : constant.JenisKelamin.perempuan,
        avatar: data['avatar'],
      );

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'id': data['id'],
          'email': data['email'],
          'name': data['name'],
          'jenis_kelamin': data['jenis_kelamin'],
          'tanggal_lahir': data['tanggal_lahir'],
          'nis': data['nis'],
          'role_id': data['role.id'],
          'role_name': data['role.name'],
          'avatar': data['avatar'],
          'token': data['token'],
        },
      );
      prefs.setString('userData', userData);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> register({
    @required String nama,
    @required DateTime birthOfDate,
    @required constant.JenisKelamin jenisKelamin,
    @required int role,
    @required String nis,
    @required String email,
    @required String password,
    @required String confirmationPassword,
    String avatar,
  }) async {
    const Map<String, String> headers = {"Content-type": "application/json"};

    String jenis = jenisKelamin == constant.JenisKelamin.laki ? 'L' : 'P';

    final Map<String, String> jsonData = {
      'name': nama,
      'jenis_kelamin': jenis,
      'role_id': role.toString(),
      'nis': nis,
      'tanggal_lahir': formatter.format(birthOfDate),
      'email': email,
      'password': password,
      'confirmation_password': confirmationPassword,
    };
    final url = Uri.http(constant.API_URL, '/api/auth/register');
    final req = http.MultipartRequest('POST', url);

    req.headers.addAll(headers);
    req.fields.addAll(jsonData);

    req.files.add(await http.MultipartFile.fromPath('avatar', avatar));

    try {
      final res = await http.Response.fromStream(await req.send());

      final bool status = res.statusCode == 201 ? true : false;
      if (!status) throw HttpException('Gagal melakukan registrasi, silahkan coba kembali.');
    } catch (err) {
      throw (err);
    }
  }

  Future<void> updateUser({
    @required String name,
    @required DateTime birthOfDate,
    @required constant.JenisKelamin jenisKelamin,
    @required int role,
    @required String nis,
    @required String avatar,
    @required String email,
  }) async {
    String jenis;
    switch (jenisKelamin) {
      case constant.JenisKelamin.laki:
        jenis = 'L';
        break;
      default:
        jenis = 'P';
    }

    Map<String, String> jsonData = {
      'name': name,
      'jenis_kelamin': jenis,
      'role': role.toString(),
      'nis': nis,
      'tanggal_lahir': formatter.format(birthOfDate),
      'email': email
    };

    if (avatar.isNotEmpty) {
      jsonData['avatar'] = avatar;
    }

    return doUpdate(jsonData);
  }

  Future<void> updatePassword(String password) async {
    String jenis;
    switch (_userdata.jenisKelamin) {
      case constant.JenisKelamin.laki:
        jenis = 'L';
        break;
      default:
        jenis = 'P';
    }

    Map<String, String> jsonData = {
      'name': _userdata.name,
      'jenis_kelamin': jenis,
      'tanggal_lahir': formatter.format(_userdata.tanggalLahir),
      'email': _userdata.email,
      'password': password
    };

    return doUpdate(jsonData);
  }

  Future<void> logout() async {
    try {
      _userdata = null;
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('userData');

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedData = json.decode(prefs.getString('userData')) as Map<String, Object>;

    _userdata = User(
      email: extractedData['email'],
      token: extractedData['token'],
      id: extractedData['id'],
      tanggalLahir: formatter.parse(extractedData['tanggal_lahir']),
      name: extractedData['name'],
      nis: extractedData['nis'],
      roleId: extractedData['role_id'],
      roleName: extractedData['role_name'],
      jenisKelamin: extractedData['jenis_kelamin'] == 'L' ? constant.JenisKelamin.laki : constant.JenisKelamin.perempuan,
      avatar: extractedData['avatar'],
    );

    notifyListeners();
    return true;
  }

  Future<void> doUpdate(Map<String, String> jsonData) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer ${_userdata.token}"};

    final url = Uri.http(constant.API_URL, '/api/user/${_userdata.id}');
    final req = http.MultipartRequest('PUT', url);

    if (jsonData.containsKey('avatar')) {
      req.files.add(await http.MultipartFile.fromPath('avatar', jsonData['avatar']));
      jsonData.remove('avatar');
    }

    req.headers.addAll(headers);
    req.fields.addAll(jsonData);

    try {
      final res = await http.Response.fromStream(await req.send());

      final bool status = res.statusCode == 200 ? true : false;

      if (!status) throw HttpException('Gagal melakukan update data, silahkan coba kembali.');

      final data = json.decode(res.body)['data'];

      _userdata = User(
        email: data['email'],
        token: _userdata.token,
        id: _userdata.id,
        name: data['name'],
        nis: data['nis'],
        roleId: _userdata.roleId,
        roleName: _userdata.roleName,
        tanggalLahir: formatter.parse(data['tanggal_lahir']),
        jenisKelamin: data['jenis_kelamin'] == 'L' ? constant.JenisKelamin.laki : constant.JenisKelamin.perempuan,
        avatar: data['avatar'],
      );
      final prefs = await SharedPreferences.getInstance();
      final userData = {
        'id': _userdata.id,
        'email': data['email'],
        'name': data['name'],
        'jenis_kelamin': data['jenis_kelamin'],
        'tanggal_lahir': data['tanggal_lahir'],
        'nis': data['nis'],
        'role_id': _userdata.roleId,
        'role_name': _userdata.roleName,
        'avatar': data['avatar'],
        'token': _userdata.token,
      };

      prefs.setString('userData', json.encode(userData));

      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }
}
