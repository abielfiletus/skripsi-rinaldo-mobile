import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/models/soal.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/quiz.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class DeleteGuruSoalDialog extends StatefulWidget {
  final User user;
  final int idx;
  final int id;
  final int quizId;
  final String soal;

  DeleteGuruSoalDialog({
    @required this.user,
    @required this.idx,
    @required this.quizId,
    @required this.id,
    @required this.soal,
  });

  @override
  _DeleteGuruSoalDialogState createState() => _DeleteGuruSoalDialogState();
}

class _DeleteGuruSoalDialogState extends State<DeleteGuruSoalDialog> {
  Soal soal;
  bool _buttonIsLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hapus Soal'),
            SizedBox(height: 15),
            Text('Soal : ${widget.soal}'),
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
                        ).deleteSoal(widget.user.token, widget.id);

                        setState(() => _buttonIsLoading = false);

                        await Provider.of<QuizProvider>(context, listen: false).getGuruList(
                          token: widget.user.token,
                          quizId: widget.quizId.toString(),
                        );
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: 'Berhasil menghapus soal');
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
                          msg: 'Gagal menghapus soal. Silakan coba lagi.',
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
