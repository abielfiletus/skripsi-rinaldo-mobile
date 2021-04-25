import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/utils/SplashScreen.dart';
import 'package:skripsi_rinaldo/modules/dashboard/dashboard.dart';
import 'package:skripsi_rinaldo/modules/login/Login.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/history.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/providers/quiz.dart';

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
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Learning From Home',
          theme: ThemeData(fontFamily: 'Notosans'),
          home: auth.isAuth
              ? DashboardPage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting ? SplashScreen() : LoginPage(),
                ),
          routes: {
            '/login': (ctx) => LoginPage(),
            '/home': (ctx) => DashboardPage(),
          },
        ),
      ),
    );
  }
}
