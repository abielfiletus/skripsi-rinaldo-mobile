import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/models/meeting.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/providers/meeting.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class DeleteGuruMeetingDialog extends StatefulWidget {
  final User user;
  final Meeting meeting;
  final int id;

  DeleteGuruMeetingDialog({
    @required this.user,
    @required this.meeting,
    @required this.id,
  });

  @override
  _DeleteGuruMeetingDialogState createState() => _DeleteGuruMeetingDialogState();
}

class _DeleteGuruMeetingDialogState extends State<DeleteGuruMeetingDialog> {
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
            Text('Hapus Meeting'),
            SizedBox(height: 15),
            Text('Meeting : ${widget.meeting.name} - ${widget.meeting.className}'),
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
                        await Provider.of<MateriProvider>(
                          context,
                          listen: false,
                        ).delete(widget.user.token, widget.id);

                        setState(() => _buttonIsLoading = false);

                        Provider.of<MeetingProvider>(context, listen: false).getList(
                          token: widget.user.token,
                          userId: widget.user.id.toString(),
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
