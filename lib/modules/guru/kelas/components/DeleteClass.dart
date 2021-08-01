import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class DeleteClassDialog extends StatefulWidget {
  final int id;
  final int userId;
  final String name;
  final String token;

  DeleteClassDialog({@required this.id, @required this.userId, @required this.name, @required this.token});

  @override
  _DeleteClassDialogState createState() => _DeleteClassDialogState();
}

class _DeleteClassDialogState extends State<DeleteClassDialog> {
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
            Text('Hapus Kelas'),
            SizedBox(height: 15),
            Text('Kelas : ${widget.name}'),
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
                        await Provider.of<KelasProvider>(context, listen: false).delete(widget.token, widget.id);

                        setState(() => _buttonIsLoading = false);

                        Provider.of<KelasProvider>(context, listen: false).guruGetClass(
                          token: widget.token,
                          userId: widget.userId,
                        );
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: 'Berhasil menghapus kelas');
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
                          msg: 'Gagal menghapus kelas. Silakan coba lagi.',
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
