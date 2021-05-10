import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/materi/components/AddClass.dart';
import 'package:skripsi_rinaldo/modules/materi/components/MateriList.dart';

import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/utils/BottomNavigation.dart';

class MateriPage extends StatefulWidget {
  @override
  _MateriPageState createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  User _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<KelasProvider>(context, listen: false).getList(token: _user.token, userId: _user.id).then((_) {
      final data = Provider.of<KelasProvider>(context, listen: false).list;

      if (data.length > 0) {
        Provider.of<MateriProvider>(context, listen: false)
            .getList(token: _user.token, userId: _user.id.toString(), classId: data[0].id.toString())
            .then((_) => setState(() => _isLoading = false));
      } else {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _materi = Provider.of<MateriProvider>(context).list;
    final _class = Provider.of<KelasProvider>(context, listen: false).list;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.book,
          color: Colors.black,
        ),
        title: Text(
          'Materi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigation(
        role: _user.roleId,
        active: 'materi',
      ),
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
                        return MateriList(
                          first: i == 0,
                          last: i == _materi.length - 1,
                          namaMateri: _materi[i].name,
                          tanggalKumpul: _materi[i].tanggalKumpul != null
                              ? DateFormat('dd MMMM yyyy').format(
                                  new DateFormat('yyyy-MM-dd').parse(_materi[i].tanggalKumpul),
                                )
                              : '-',
                          status: _materi[i].tanggalKumpul != null ? _materi[i].status ?? 'Belum Kumpul' : '-',
                          path: _materi[i].path,
                          quizId: _materi[i].quiz.id,
                          materiId: _materi[i].id,
                          classId: _materi[i].classId,
                          historyId: _materi[i].historyId,
                          token: _user.token,
                          userId: _user.id,
                        );
                      },
                    )
                  : Container(
                      child: Text(
                        _class.length > 0 ? 'Belum ada materi.' : 'Anda belum terdaftar dalam kelas apapun.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      width: double.infinity),
        ),
      ),
      floatingActionButton: _class.length > 0
          ? SizedBox()
          : FloatingActionButton(
              onPressed: () => _showDialog(),
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      builder: (context) => AddClassDialog(user: _user),
      context: context,
    );
  }
}
