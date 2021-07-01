import 'package:flutter/material.dart';

import 'package:skripsi_rinaldo/utils/ButtonIcon.dart';
import 'package:skripsi_rinaldo/modules/profile/Profile.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/dashboard/Dashboard.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/meeting/Meeting.dart';

class BottomNavigationOrtu extends StatelessWidget {
  final String active;

  BottomNavigationOrtu(this.active);

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
            borderSideTop: active == 'home' ? BorderSide(color: Colors.black, width: 2) : BorderSide(color: Colors.transparent),
            onPress: () {
              if (active != 'home') Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => DashboardOrtuPage()));
            },
          ),
          ButtonIcon(
            icon: active == 'meeting' ? Icon(Icons.text_snippet) : Icon(Icons.text_snippet_outlined),
            text: 'Meeting',
            fontWeight: active == 'meeting' ? FontWeight.bold : FontWeight.normal,
            borderSideTop:
                active == 'meeting' ? BorderSide(color: Colors.black, width: 2) : BorderSide(color: Colors.transparent),
            onPress: () {
              if (active != 'meeting') Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => MeetingOrtuPage()));
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
