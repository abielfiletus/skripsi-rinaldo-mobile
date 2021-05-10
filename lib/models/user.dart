import 'package:skripsi_rinaldo/utils/Constants.dart';

class User {
  final int id;
  final String email;
  final String name;
  final int roleId;
  final String roleName;
  final JenisKelamin jenisKelamin;
  final String nis;
  final DateTime tanggalLahir;
  final String avatar;
  final String token;

  User({
    this.id,
    this.email,
    this.name,
    this.jenisKelamin,
    this.tanggalLahir,
    this.nis,
    this.roleId,
    this.roleName,
    this.avatar,
    this.token,
  });
}
