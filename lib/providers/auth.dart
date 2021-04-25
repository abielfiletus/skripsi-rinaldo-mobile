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
    // const Map<String, String> headers = {"Content-type": "application/json"};
    // final String jsonData = json.encode({
    //   "email": email,
    //   "password": pass,
    // });

    try {
      // final res = await http.post(
      //   'http://' + constant.API_URL + '/api/auth/login',
      //   body: jsonData,
      //   headers: headers,
      // );

      // final bool status = json.decode(res.body)['status'];

      // if (!status) throw HttpException('Kombinasi email dan password tidak sesuai.');

      // final data = json.decode(res.body)['result'];
      // print(data);

      const Map<String, dynamic> data = {
        'id': 1,
        'email': 'rinaldo@gmail.com',
        'name': 'Rinaldo Nazario',
        'jenis_kelamin': 'L',
        'tanggal_lahir': '1997-04-30',
        'nis': 1234567890,
        'role_id': 2,
        'role_name': 'siswa',
        'token': 'asdasdasdasd',
      };

      _userdata = User(
        email: data['email'],
        token: data['token'],
        id: data['id'],
        tanggalLahir: formatter.parse(data['tanggal_lahir']),
        name: data['name'],
        nis: data['nis'],
        roleId: data['role_id'],
        roleName: data['role_name'],
        jenisKelamin: data['jenis_kelamin'] == 'L' ? constant.JenisKelamin.laki : constant.JenisKelamin.perempuan,
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
          'role_id': data['role_id'],
          'role_name': data['role_name'],
          'token': data['token'],
        },
      );
      prefs.setString('userData', userData);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> register(
    String nama,
    DateTime birthOfDate,
    constant.JenisKelamin jenisKelamin,
    int role,
    String nis,
    String email,
    String password,
    String confirmationPassword,
  ) async {
    const Map<String, String> headers = {"Content-type": "application/json"};

    String jenis = jenisKelamin == constant.JenisKelamin.laki ? 'L' : 'P';

    String jsonData = json.encode({
      'name': nama,
      'jenis_kelamin': jenis,
      'no_hp': role,
      'status_pekerjaan': nis,
      'tanggal_lahir': formatter.format(birthOfDate),
      'email': email,
      'password': password,
      'confirmation_password': confirmationPassword
    });
    try {
      final res = await http.post(
        'http://' + constant.API_URL + '/api/auth/register',
        body: jsonData,
        headers: headers,
      );

      final bool status = json.decode(res.body)['status'];
      if (!status) throw HttpException(json.decode(res.body)['err'].toString().replaceAll(RegExp(r'[\{\}\:]'), ''));
    } catch (err) {
      throw (err);
    }
  }

  Future<void> updateUser(
    String nama,
    DateTime birthOfDate,
    constant.JenisKelamin jenisKelamin,
    int role,
    String nis,
    String email,
  ) async {
    String jenis;
    switch (jenisKelamin) {
      case constant.JenisKelamin.laki:
        jenis = 'L';
        break;
      default:
        jenis = 'P';
    }

    String jsonData = json.encode({
      'name': nama,
      'jenis_kelamin': jenis,
      'role': role,
      'nis': nis,
      'tanggal_lahir': formatter.format(birthOfDate),
      'email': email
    });

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

    String jsonData = json.encode({
      'id': _userdata.id,
      'name': _userdata.name,
      'jenis_kelamin': jenis,
      'tanggal_lahir': formatter.format(_userdata.tanggalLahir),
      'email': _userdata.email,
      'password': password
    });

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
    print(extractedData['tanggalLahir']);
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
    );

    notifyListeners();
    return true;
  }

  Future<void> doUpdate(jsonData) async {
    final Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer ${_userdata.token}"};

    try {
      final res = await http.put(
        'http://' + constant.API_URL + '/api/auth/register',
        body: jsonData,
        headers: headers,
      );

      final bool status = json.decode(res.body)['status'];

      if (!status) throw HttpException(json.decode(res.body)['error']);

      final data = json.decode(res.body)['data'];

      _userdata = User(
        email: _userdata.email,
        token: _userdata.token,
        id: _userdata.id,
        name: _userdata.name,
        nis: _userdata.nis,
        roleId: _userdata.roleId,
        tanggalLahir: formatter.parse(data['tanggal_lahir']),
        jenisKelamin: data['jenis_kelamin'] == 'L' ? constant.JenisKelamin.laki : constant.JenisKelamin.perempuan,
      );
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'email': _userdata.email,
          'token': _userdata.token,
          'id': _userdata.id,
          'name': data['name'],
          'jenis_kelamin': data['jenis_kelamin'],
          'tanggal_lahir': data['tanggal_lahir'],
          'nis': data['nis'],
          'role_id': data['role_id'],
          'role_name': data['role_name'],
        },
      );
      prefs.setString('userData', userData);

      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }
}
