import 'package:flutter/material.dart';

import 'package:skripsi_rinaldo/utils/ButtonIcon.dart';
import 'package:skripsi_rinaldo/modules/profile/Profile.dart';
import 'package:skripsi_rinaldo/modules/murid/dashboard/Dashboard.dart';
import 'package:skripsi_rinaldo/modules/murid/histories/History.dart';
import 'package:skripsi_rinaldo/modules/murid/materi/Materi.dart';

class BottomNavigationMurid extends StatelessWidget {
  final String active;

  BottomNavigationMurid(this.active);

  @override
  Widget build(BuildContext context) {
    
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
                  if (active != 'home') Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => DashboardMuridPage()));
                },
              ),
              ButtonIcon(
                icon: active == 'materi' ? Icon(Icons.book) : Icon(Icons.book_outlined),
                text: 'Materi',
                fontWeight: active == 'materi' ? FontWeight.bold : FontWeight.normal,
                borderSideTop:
                    active == 'materi' ? BorderSide(color: Colors.black, width: 2) : BorderSide(color: Colors.transparent),
                onPress: () {
                  if (active != 'materi') Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => MateriMuridPage()));
                },
              ),
              ButtonIcon(
                icon: active == 'history' ? Icon(Icons.history) : Icon(Icons.history_outlined),
                text: 'History',
                fontWeight: active == 'history' ? FontWeight.bold : FontWeight.normal,
                borderSideTop:
                    active == 'history' ? BorderSide(color: Colors.black, width: 2) : BorderSide(color: Colors.transparent),
                onPress: () {
                  if (active != 'history') Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => HistoryMuridPage()));
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
  }
}
