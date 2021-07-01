import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/models/meeting.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/providers/meeting.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class AddGuruUsulanMeetingDialog extends StatefulWidget {
  final User user;
  final Meeting meeting;
  final int id;
  final int idx;

  AddGuruUsulanMeetingDialog({
    @required this.user,
    this.idx,
    this.id,
    this.meeting,
  });

  @override
  _AddGuruUsulanMeetingDialogState createState() => _AddGuruUsulanMeetingDialogState();
}

class _AddGuruUsulanMeetingDialogState extends State<AddGuruUsulanMeetingDialog> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  DateTime _startDate;
  DateTime _endDate;
  bool _isLoading = false;
  bool _buttonIsLoading = false;
  int kelas;

  @override
  void initState() {
    Provider.of<KelasProvider>(context, listen: false).guruGetClass(token: widget.user.token, userId: widget.user.id).then((_) {
      setState(() => _isLoading = false);
    });

    if (widget.meeting != null) {
      setState(() {
        nameController.text = widget.meeting.name;
        descriptionController.text = widget.meeting.description;
        _startDate = widget.meeting.startDate;
        _endDate = widget.meeting.endDate;
        kelas = widget.meeting.classId;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kelasList = Provider.of<KelasProvider>(context).list;
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
                      widget.id != null ? 'Ubah Usulan Meeting' : 'Tambah Usulan Meeting Baru',
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
                              name: 'class',
                              initialValue: kelas,
                              decoration: InputDecoration(
                                labelText: 'Kelas',
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
                              onChanged: (val) => setState(() => kelas = val),
                            ),
                            SizedBox(height: 15),
                            FormBuilderTextField(
                              name: 'name',
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Nama',
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
                            ),
                            SizedBox(height: 15),
                            FormBuilderTextField(
                              name: 'description',
                              controller: descriptionController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Deskripsi',
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
                                            await Provider.of<MeetingProvider>(context, listen: false).update(
                                              token: widget.user.token,
                                              id: widget.id,
                                              idx: widget.idx,
                                              name: nameController.text,
                                              start: DateFormat('yyyy-MM-dd HH:mm').format(_startDate),
                                              end: DateFormat('yyyy-MM-dd HH:mm').format(_endDate),
                                              classId: kelas,
                                              description: descriptionController.text,
                                            );
                                          } else {
                                            await Provider.of<MeetingProvider>(context, listen: false).create(
                                              token: widget.user.token,
                                              name: nameController.text,
                                              start: DateFormat('yyyy-MM-dd HH:mm').format(_startDate),
                                              end: DateFormat('yyyy-MM-dd HH:mm').format(_endDate),
                                              classId: kelas,
                                              description: descriptionController.text,
                                            );
                                          }
                                          setState(() => _buttonIsLoading = false);
                                          Provider.of<MeetingProvider>(context, listen: false).getList(
                                            token: widget.user.token,
                                            userId: widget.user.id.toString(),
                                          );
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: widget.id != null
                                                ? 'Berhasil mengubah usulan meeting'
                                                : 'Berhasil membuat usulan meeting',
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
                                                ? 'Gagal mengubah usulan meeting. Silakan coba lagi.'
                                                : 'Gagal membuat usulan meeting. Silakan coba lagi.',
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
