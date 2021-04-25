import 'package:flutter/material.dart';

import 'package:skripsi_rinaldo/utils/ButtonIcon.dart';
import 'package:skripsi_rinaldo/modules/dashboard/Dashboard.dart';
import 'package:skripsi_rinaldo/modules/profile/Profile.dart';
import 'package:skripsi_rinaldo/modules/materi/Materi.dart';
import 'package:skripsi_rinaldo/modules/histories/History.dart';

class BottomNavigation extends StatelessWidget {
  final int role;
  final String active;

  BottomNavigation({@required this.role, @required this.active});

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case 1:
        return Container();
        break;
      case 2:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26, spreadRadius: 1)],
          ),
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonIcon(
                icon: active == 'home' ? Icon(Icons.home) : Icon(Icons.home_outlined),
                text: 'Home',
                fontWeight: active == 'home' ? FontWeight.bold : FontWeight.normal,
                borderSideTop:
                    active == 'home' ? BorderSide(color: Colors.black, width: 2) : BorderSide(color: Colors.transparent),
                onPress: () {
                  if (active != 'home') Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => DashboardPage()));
                },
              ),
              ButtonIcon(
                icon: active == 'materi' ? Icon(Icons.book) : Icon(Icons.book_outlined),
                text: 'Materi',
                fontWeight: active == 'materi' ? FontWeight.bold : FontWeight.normal,
                borderSideTop:
                    active == 'materi' ? BorderSide(color: Colors.black, width: 2) : BorderSide(color: Colors.transparent),
                onPress: () {
                  if (active != 'materi') Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => MateriPage()));
                },
              ),
              ButtonIcon(
                icon: active == 'history' ? Icon(Icons.history) : Icon(Icons.history_outlined),
                text: 'History',
                fontWeight: active == 'history' ? FontWeight.bold : FontWeight.normal,
                borderSideTop:
                    active == 'history' ? BorderSide(color: Colors.black, width: 2) : BorderSide(color: Colors.transparent),
                onPress: () {
                  if (active != 'history') Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => HistoryPage()));
                },
              ),
              ButtonIcon(
                icon: active == 'profile' ? Icon(Icons.person) : Icon(Icons.person_outline),
                text: 'Profile',
                fontWeight: active == 'profile' ? FontWeight.bold : FontWeight.normal,
                borderSideTop:
                    active == 'profile' ? BorderSide(color: Colors.black, width: 2) : BorderSide(color: Colors.transparent),
                onPress: () {
                  if (active != 'profile') Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => ProfilePage()));
                },
              ),
            ],
          ),
        );
        break;
      default:
        return Container();
    }
    ;
  }
}
