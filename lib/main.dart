import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/providers/Ortu.dart';

import 'package:skripsi_rinaldo/utils/SplashScreen.dart';
import 'package:skripsi_rinaldo/modules/guru/dashboard/Dashboard.dart';
import 'package:skripsi_rinaldo/modules/murid/dashboard/Dashboard.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/dashboard/Dashboard.dart';
import 'package:skripsi_rinaldo/modules/login/Login.dart';
import 'package:skripsi_rinaldo/providers/dashboard.dart';
import 'package:skripsi_rinaldo/providers/meeting.dart';
import 'package:skripsi_rinaldo/providers/student.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/history.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/providers/quiz.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => MateriProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => KelasProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => MeetingProvider()),
        ChangeNotifierProvider(create: (_) => OrtuProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Learning From Home',
          theme: ThemeData(fontFamily: 'Notosans'),
          home: auth.isAuth
              ? dashboard(auth.user.roleId)
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting ? SplashScreen() : LoginPage(),
                ),
        ),
      ),
    );
  }

  Widget dashboard(role) {
    switch (role) {
      case 1:
        return DashboardGuruPage();
        break;
      case 2:
        return DashboardMuridPage();
        break;
      default:
        return DashboardOrtuPage();
    }
  }
}
