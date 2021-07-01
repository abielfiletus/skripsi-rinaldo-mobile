import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/guru/quiz/components/AddQuiz.dart';
import 'package:skripsi_rinaldo/modules/guru/quiz/components/AddSoal.dart';
import 'package:skripsi_rinaldo/modules/guru/quiz/components/QuizList.dart';
import 'package:skripsi_rinaldo/providers/quiz.dart';

class QuizGuruPage extends StatefulWidget {
  final int quizId;
  final String materiName;
  final User user;

  QuizGuruPage(this.materiName, this.quizId, this.user);

  @override
  _QuizGuruPageState createState() => _QuizGuruPageState();
}

class _QuizGuruPageState extends State<QuizGuruPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<QuizProvider>(context, listen: false)
        .getGuruList(token: widget.user.token, quizId: widget.quizId.toString())
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final _quiz = Provider.of<QuizProvider>(context).list;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.keyboard_backspace_rounded, color: Colors.black),
        title: Text(
          widget.materiName,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationGuru('kelas'),
      body: ChangeNotifierProvider(
        create: (_) => QuizProvider(),
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
              : _quiz.length > 0
                  ? ListView.builder(
                      itemCount: _quiz.length,
                      itemBuilder: (ctx, i) => QuizListGuru(_quiz[i], i, widget.user),
                    )
                  : Container(
                      child: Text(
                        'Belum ada soal di quiz ini.',
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
      builder: (context) => AddGuruSoalDialog(user: widget.user, quizId: widget.quizId),
      context: context,
    );
  }
}
