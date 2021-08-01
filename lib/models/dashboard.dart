import 'package:skripsi_rinaldo/models/dashboardMateri.dart';
import 'package:skripsi_rinaldo/models/summary.dart';
import 'package:skripsi_rinaldo/models/usulanMeeting.dart';

class Dashboard {
  final Summary summary;
  final List<UsulanMeeting> meeting;
  final List<DashboardMateri> materi;

  Dashboard({
    this.summary,
    this.meeting,
    this.materi,
  });
}
