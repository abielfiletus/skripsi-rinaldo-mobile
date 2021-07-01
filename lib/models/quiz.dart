import 'package:skripsi_rinaldo/models/soal.dart';

class Quiz {
  final int id;
  final String name;
  final String tanggalKumpul;
  final int totalSoal;
  final int nilaiLulus;
  final int classMateriId;
  final List<Soal> soal;

  Quiz({
    this.id,
    this.name,
    this.tanggalKumpul,
    this.totalSoal,
    this.nilaiLulus,
    this.classMateriId,
    this.soal,
  });
}
