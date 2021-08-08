import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/models/usulanMeeting.dart';
import 'package:skripsi_rinaldo/providers/meeting.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class AddGuruMeetingDialog extends StatefulWidget {
  final User user;
  final UsulanMeeting meeting;
  final int id;
  final int idx;

  AddGuruMeetingDialog({
    @required this.user,
    this.idx,
    this.id,
    this.meeting,
  });

  @override
  _AddGuruMeetingDialogState createState() => _AddGuruMeetingDialogState();
}

class _AddGuruMeetingDialogState extends State<AddGuruMeetingDialog> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  TextEditingController linkController = new TextEditingController();

  DateTime _startDate;
  DateTime _endDate;
  bool _isLoading = false;
  bool _buttonIsLoading = false;
  int usulanMeeting;

  @override
  void initState() {
    Provider.of<MeetingProvider>(context, listen: false)
        .getListUsulan(token: widget.user.token, userId: widget.user.id.toString())
        .then((_) {
      setState(() => _isLoading = false);
    });

    if (widget.meeting != null) {
      setState(() {
        linkController.text = widget.meeting.name;
        _startDate = widget.meeting.start;
        _endDate = widget.meeting.end;
        usulanMeeting = widget.meeting.id;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kelasList = Provider.of<MeetingProvider>(context).listUsulan;
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
                      widget.id != null ? 'Ubah Meeting' : 'Tambah Meeting Baru',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: MediaQuery.of(context).size.height - 120,
                      child: FormBuilder(
                        key: globalFormKey,
                        child: Column(
                          children: [
                            FormBuilderDropdown(
                              name: 'usulan meeting',
                              initialValue: usulanMeeting,
                              decoration: InputDecoration(
                                labelText: 'Usulan Meeting',
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
                              ]),
                              items: kelasList
                                  .map((item) => DropdownMenuItem(
                                        child: Text(item.name),
                                        value: item.id,
                                      ))
                                  .toList(),
                              onChanged: (val) => setState(() => usulanMeeting = val),
                            ),
                            SizedBox(height: 15),
                            FormBuilderTextField(
                              name: 'link',
                              controller: linkController,
                              decoration: InputDecoration(
                                labelText: 'Link',
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
                            ),
                            SizedBox(height: 15),
                            FormBuilderDateTimePicker(
                              name: 'start date',
                              initialValue: _startDate,
                              firstDate: DateTime(1700),
                              lastDate: DateTime(new DateTime.now().year, 12),
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
                              ]),
                              onChanged: (value) => setState(() => _startDate = value),
                            ),
                            SizedBox(height: 15),
                            FormBuilderDateTimePicker(
                              name: 'end date',
                              initialValue: _endDate,
                              firstDate: DateTime(1700),
                              lastDate: DateTime(new DateTime.now().year, 12),
                              format: DateFormat('yyyy-MM-dd HH:mm'),
                              decoration: InputDecoration(
                                labelText: 'Tanggal Selesai',
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
                              ]),
                              onChanged: (value) => setState(() => _endDate = value),
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
                                          if (widget.id != null) {
                                            await Provider.of<MeetingProvider>(context, listen: false).updateMeeting(
                                              token: widget.user.token,
                                              id: widget.id,
                                              idx: widget.idx,
                                              start: DateFormat('yyyy-MM-dd HH:mm').format(_startDate),
                                              end: DateFormat('yyyy-MM-dd HH:mm').format(_endDate),
                                              link: linkController.text,
                                              usulanMeetingId: usulanMeeting,
                                            );
                                          } else {
                                            await Provider.of<MeetingProvider>(context, listen: false).createMeeting(
                                              token: widget.user.token,
                                              start: DateFormat('yyyy-MM-dd HH:mm').format(_startDate),
                                              end: DateFormat('yyyy-MM-dd HH:mm').format(_endDate),
                                              link: linkController.text,
                                              usulanMeetingId: usulanMeeting,
                                            );
                                          }
                                          setState(() => _buttonIsLoading = false);
                                          Provider.of<MeetingProvider>(context, listen: false).getListMeeting(
                                            token: widget.user.token,
                                            nis: widget.user.nis,
                                          );
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: widget.id != null
                                                ? 'Berhasil mengubah meeting'
                                                : 'Berhasil membuat meeting',
                                          );
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
                                            msg: widget.id != null
                                                ? 'Gagal mengubah meeting. Silakan coba lagi.'
                                                : 'Gagal membuat meeting. Silakan coba lagi.',
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
