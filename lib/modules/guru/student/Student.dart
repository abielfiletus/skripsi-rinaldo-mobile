import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/modules/guru/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/guru/student/components/StudentList.dart';
import 'package:skripsi_rinaldo/models/Kelas.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/student.dart';

class StudentPage extends StatefulWidget {
  final User user;
  final Kelas kelas;

  StudentPage(this.user, this.kelas);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  bool _isLoading = true;

  @override
  void initState() {
    Provider.of<StudentProvider>(context, listen: false)
        .getList(widget.user.token, widget.kelas.id)
        .then((_) => setState(() => _isLoading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<StudentProvider>(context).list;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.kelas.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationGuru('kelas'),
      body: ChangeNotifierProvider(
        create: (_) => StudentProvider(),
        child: Container(
          margin: EdgeInsets.all(10),
          child: _isLoading
              ? Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Please Wait...'),
                    ],
                  ),
                )
              : list.length > 0
                  ? ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (ctx, i) => StudentList(list[i], widget.user, widget.kelas.id),
                    )
                  : Container(
                      child: Text(
                        'Belum ada murid yang mendaftar dalam kelas ini',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      width: double.infinity),
        ),
      ),
    );
  }
}
