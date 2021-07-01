import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/materi.dart';

import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/providers/quiz.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class DeleteGuruQuizDialog extends StatefulWidget {
  final User user;
  final int idx;
  final int id;
  final int classId;

  DeleteGuruQuizDialog({
    @required this.user,
    @required this.idx,
    @required this.classId,
    @required this.id,
  });

  @override
  _DeleteGuruQuizDialogState createState() => _DeleteGuruQuizDialogState();
}

class _DeleteGuruQuizDialogState extends State<DeleteGuruQuizDialog> {
  Materi materi;
  bool _isLoading = true;
  bool _buttonIsLoading = false;

  @override
  void initState() {
    materi = Provider.of<MateriProvider>(context, listen: false).detail(widget.idx);
    setState(() => _isLoading = false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: _isLoading
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
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hapus Quiz'),
                  SizedBox(height: 15),
                  Text('Quiz : ${materi.quiz.name}'),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          splashColor: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Cancel', style: TextStyle(color: Colors.white)),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(width: 10),
                      Material(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          splashColor: Colors.black12,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: _buttonIsLoading
                                ? Text(
                                    "Please Wait...",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                : Text('Delete', style: TextStyle(color: Colors.white)),
                          ),
                          onTap: () async {
                            setState(() => _buttonIsLoading = true);
                            try {
                              await Provider.of<QuizProvider>(
                                context,
                                listen: false,
                              ).delete(widget.user.token, widget.id);

                              setState(() => _buttonIsLoading = false);

                              await Provider.of<MateriProvider>(context, listen: false).guruGetList(
                                token: widget.user.token,
                                classId: widget.classId.toString(),
                              );
                              Navigator.pop(context);
                              Fluttertoast.showToast(msg: 'Berhasil menghapus materi');
                            } on HttpException catch (err) {
                              setState(() => _buttonIsLoading = false);
                              Fluttertoast.showToast(
                                msg: err.toString(),
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            } catch (err) {
                              setState(() => _buttonIsLoading = false);
                              print(err);
                              Fluttertoast.showToast(
                                msg: 'Gagal menghapus materi. Silakan coba lagi.',
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
