import 'package:skripsi_rinaldo/models/quiz.dart';

class Materi {
  final int id;
  final String name;
  final String path;
  final String tanggalKumpul;
  final int classId;
  final String className;
  final Quiz quiz;
  final String historyId;
  final String status;

  Materi({
    this.id,
    this.name,
    this.path,
    this.classId,
    this.className,
    this.quiz,
    this.status,
    this.tanggalKumpul,
    this.historyId,
  });
}
