import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/student.dart';

import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/providers/student.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class DeleteStudentGuruDialog extends StatefulWidget {
  final User user;
  final Student student;
  final int classId;

  DeleteStudentGuruDialog({
    @required this.user,
    @required this.student,
    @required this.classId,
  });

  @override
  _DeleteStudentMaterGurugState createState() => _DeleteStudentMaterGurugState();
}

class _DeleteStudentMaterGurugState extends State<DeleteStudentGuruDialog> {
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
            Text('Hapus Murid'),
            SizedBox(height: 15),
            Container(
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.student.avatar,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(widget.student.name),
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
                        await Provider.of<StudentProvider>(context, listen: false).delete(widget.user.token, widget.student.id);

                        setState(() => _buttonIsLoading = false);

                        await Provider.of<StudentProvider>(context, listen: false).getList(widget.user.token, widget.classId);
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: 'Berhasil menghapus mmurid');
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
                          msg: 'Gagal menghapus murid. Silakan coba lagi.',
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
