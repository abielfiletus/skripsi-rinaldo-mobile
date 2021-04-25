import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:skripsi_rinaldo/modules/register/components/Form.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Form Register',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: FormRegister(),
    );
  }
}
