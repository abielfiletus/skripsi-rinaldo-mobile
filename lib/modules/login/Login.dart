import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:skripsi_rinaldo/modules/login/components/LoginBody.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: MediaQuery.of(context).padding.top + 30,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Selamat datang',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(height: 15),
              LoginBody()
            ],
          ),
        ),
      ),
    );
  }
}
