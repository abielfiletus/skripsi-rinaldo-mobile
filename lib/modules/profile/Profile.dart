import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/modules/guru/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/BottomNavigation.dart';

import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/modules/murid/BottomNavigation.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/profile/components/ProfileBody.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User _user;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.person,
          color: Colors.black,
        ),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: bottomNavigation(_user.roleId),
      body: ProfileBody(_user),
    );
  }

  Widget bottomNavigation(role) {
    switch (role) {
      case 1:
        return BottomNavigationGuru('profile');
        break;
      case 2:
        return BottomNavigationMurid('profile');
        break;
      default:
        return BottomNavigationOrtu('profile');
    }
  }
}
