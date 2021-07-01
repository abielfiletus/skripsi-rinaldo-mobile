import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/models/meeting.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/Ortu.dart';
import 'package:skripsi_rinaldo/providers/meeting.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class AddOrtuUsulanMeetingDialog extends StatefulWidget {
  final User user;
  final Meeting meeting;
  final int id;
  final int idx;

  AddOrtuUsulanMeetingDialog({
    @required this.user,
    this.idx,
    this.id,
    this.meeting,
  });

  @override
  _AddOrtuUsulanMeetingDialogState createState() => _AddOrtuUsulanMeetingDialogState();
}

class _AddOrtuUsulanMeetingDialogState extends State<AddOrtuUsulanMeetingDialog> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();

  DateTime _date;
  bool _isLoading = false;
  bool _buttonIsLoading = false;

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
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Form Usulan Meeting',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: MediaQuery.of(context).size.height - 120,
                      child: FormBuilder(
                        key: globalFormKey,
                        child: Column(
                          children: [
                            Text(widget.meeting.name),
                            SizedBox(height: 15),
                            FormBuilderDateTimePicker(
                              name: 'start date',
                              initialValue: widget.meeting.startDate,
                              firstDate: widget.meeting.startDate,
                              lastDate: widget.meeting.endDate,
                              format: DateFormat('yyyy-MM-dd HH:mm'),
                              decoration: InputDecoration(
                                labelText: 'Tanggal Mulai',
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black26,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context, errorText: 'harus terisi'),
                                (val) {
                                  var check1 = val.add(Duration(hours: 7)).toUtc().difference(widget.meeting.startDate);
                                  if (check1.inMinutes < 0) return 'harus lebih besar dari tanggal mulai';

                                  var check2 = val.add(Duration(hours: 7)).toUtc().difference(widget.meeting.endDate);
                                  if (check2.inMinutes > 0) return 'harus lebih kecil dari tanggal selesai';

                                  return null;
                                }
                              ]),
                              onChanged: (value) => setState(() => _date = value),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    splashColor: Colors.black12,
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
                                          : Text('Submit', style: TextStyle(color: Colors.white)),
                                    ),
                                    onTap: () async {
                                      if (validateAndSave()) {
                                        setState(() => _buttonIsLoading = true);

                                        try {
                                          await Provider.of<MeetingProvider>(context, listen: false).createUsulanMeetingOrtu(
                                            token: widget.user.token,
                                            usulanMeetingId: widget.meeting.id,
                                            userId: widget.user.id,
                                            date: DateFormat('yyyy-MM-dd HH:mm').format(_date),
                                          );
                                          setState(() => _buttonIsLoading = false);
                                          Provider.of<OrtuProvider>(context, listen: false).getList(
                                            widget.user.token,
                                            widget.user.id,
                                          );
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(msg: 'Berhasil mengisi form');
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
                                            msg: 'Gagal mengisi form. Silakan coba lagi.',
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
