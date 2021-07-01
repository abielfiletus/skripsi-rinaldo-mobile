import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';

import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/guru/materi/components/AddMateri.dart';
import 'package:skripsi_rinaldo/modules/guru/materi/components/MateriList.dart';

class MateriGuruPage extends StatefulWidget {
  final int classId;
  final String className;

  MateriGuruPage(this.className, this.classId);

  @override
  _MateriGuruPageState createState() => _MateriGuruPageState();
}

class _MateriGuruPageState extends State<MateriGuruPage> {
  User _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<MateriProvider>(context, listen: false)
        .guruGetList(token: _user.token, classId: widget.classId.toString())
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final _materi = Provider.of<MateriProvider>(context).list;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.className,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationGuru('kelas'),
      body: ChangeNotifierProvider(
        create: (_) => KelasProvider(),
        child: Container(
          margin: EdgeInsets.all(10),
          child: _isLoading
              ? Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator(), SizedBox(height: 10), Text('Please Wait...')],
                  ),
                )
              : _materi.length > 0
                  ? ListView.builder(
                      itemCount: _materi.length,
                      itemBuilder: (ctx, i) {
                        return MateriGuruList(
                          first: i == 0,
                          last: i == _materi.length - 1,
                          materi: _materi[i],
                          token: _user.token,
                          user: _user,
                          idx: i,
                        );
                      },
                    )
                  : Container(
                      child: Text(
                        'Belum ada materi di kelas ini.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      width: double.infinity),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      builder: (context) => AddGuruMateriDialog(
        classId: widget.classId,
        className: widget.className,
        user: _user,
      ),
      context: context,
    );
  }
}
