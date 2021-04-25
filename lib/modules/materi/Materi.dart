import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/modules/materi/components/MateriList.dart';

import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/utils/BottomNavigation.dart';

class MateriPage extends StatefulWidget {
  @override
  _MateriPageState createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  int _role;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _role = Provider.of<AuthProvider>(context, listen: false).user.roleId;
    setState(() => _isLoading = true);

    Provider.of<MateriProvider>(context, listen: false).getList(token: 'asdada').then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final _materi = Provider.of<MateriProvider>(context).list;

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
        role: _role,
        active: 'materi',
      ),
      body: ChangeNotifierProvider(
        create: (_) => MateriProvider(),
        child: Container(
          margin: EdgeInsets.all(10),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _materi.length > 0
                  ? ListView.builder(
                      itemCount: _materi.length,
                      itemBuilder: (ctx, i) {
                        return MateriList(
                          first: i == 0,
                          last: i == _materi.length - 1,
                          namaMateri: _materi[i].name,
                          tanggalKumpul: DateFormat('dd MMMM yyyy').format(
                            new DateFormat('yyyy-MM-dd').parse(_materi[i].tanggalKumpul),
                          ),
                          status: _materi[i].status,
                          path: _materi[i].path,
                          quizId: _materi[i].quiz.id,
                        );
                      },
                    )
                  : Container(
                      child: Text(
                        'Tidak ada data.',
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
