import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/modules/guru/student-quiz-history/components/StudentQuizHistoryList.dart';

import 'package:skripsi_rinaldo/providers/history.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/guru/materi/components/AddMateri.dart';
import 'package:skripsi_rinaldo/modules/guru/materi/components/MateriList.dart';

class StudentQuizHistoryPage extends StatefulWidget {
  final int classMateriId;
  final String className;
  final User user;

  StudentQuizHistoryPage(this.className, this.classMateriId, this.user);

  @override
  _StudentQuizHistoryPageState createState() => _StudentQuizHistoryPageState();
}

class _StudentQuizHistoryPageState extends State<StudentQuizHistoryPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<HistoryProvider>(context, listen: false)
        .getList(token: widget.user.token, classMateriId: widget.classMateriId.toString())
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final _history = Provider.of<HistoryProvider>(context).list;

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
        create: (_) => HistoryProvider(),
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
              : _history.length > 0
                  ? ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (ctx, i) {
                        return StudentQuizHistoryList(_history[i], widget.user);
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
    );
  }
}
