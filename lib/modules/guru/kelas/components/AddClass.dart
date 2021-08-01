import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class AddGuruClassDialog extends StatefulWidget {
  final User user;
  final int id;
  final int idx;

  AddGuruClassDialog({@required this.user, this.idx, this.id});

  @override
  _AddGuruClassDialogState createState() => _AddGuruClassDialogState();
}

class _AddGuruClassDialogState extends State<AddGuruClassDialog> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController nilaiMinController = new TextEditingController();

  DateTime _startDate;
  DateTime _endDate;
  bool _isLoading = true;
  bool _buttonIsLoading = false;

  @override
  void initState() {
    if (widget.id != null) {
      Provider.of<KelasProvider>(context, listen: false).getDetailClass(token: widget.user.token, id: widget.id).then(
        (_) {
          final data = Provider.of<KelasProvider>(context, listen: false).detail;
          setState(() {
            _isLoading = false;
            nameController.text = data.name;
            nilaiMinController.text = data.nilaiMinimum.toString();
            _startDate = data.start;
            _endDate = data.end;
          });
        },
      );
    } else {
      setState(() => _isLoading = false);
    }
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
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.id != null ? 'Ubah Kelas' : 'Tambah Kelas Baru',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 400,
                      child: FormBuilder(
                        key: globalFormKey,
                        child: Column(
                          children: [
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
                            FormBuilderDateTimePicker(
                              name: 'start date',
                              initialValue: _startDate,
                              inputType: InputType.date,
                              firstDate: DateTime(1700),
                              lastDate: DateTime(new DateTime.now().year, 12),
                              format: DateFormat('yyyy-MM-dd'),
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
                              onChanged: (value) => setState(
                                () => _startDate = value,
                              ),
                            ),
                            SizedBox(height: 15),
                            FormBuilderDateTimePicker(
                              name: 'end date',
                              initialValue: _endDate,
                              inputType: InputType.date,
                              firstDate: DateTime(1700),
                              lastDate: DateTime(new DateTime.now().year, 12),
                              format: DateFormat('yyyy-MM-dd'),
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
                              onChanged: (value) => setState(
                                () => _endDate = value,
                              ),
                            ),
                            SizedBox(height: 15),
                            FormBuilderTextField(
                              name: 'nilai minimum',
                              keyboardType: TextInputType.number,
                              controller: nilaiMinController,
                              decoration: InputDecoration(
                                labelText: 'Nilai Lulus',
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
                                            await Provider.of<KelasProvider>(context, listen: false).update(
                                              token: widget.user.token,
                                              id: widget.id,
                                              idx: widget.idx,
                                              name: nameController.text,
                                              start: DateFormat('yyyy-MM-dd').format(_startDate),
                                              end: DateFormat('yyyy-MM-dd').format(_endDate),
                                              nilai: nilaiMinController.text,
                                            );
                                          } else {
                                            setState(() => _buttonIsLoading = false);
                                            await Provider.of<KelasProvider>(context, listen: false).create(
                                              token: widget.user.token,
                                              name: nameController.text,
                                              start: DateFormat('yyyy-MM-dd').format(_startDate),
                                              end: DateFormat('yyyy-MM-dd').format(_endDate),
                                              nilai: nilaiMinController.text,
                                            );
                                          }
                                          setState(() => _buttonIsLoading = false);
                                          Provider.of<KelasProvider>(context, listen: false).guruGetClass(
                                            token: widget.user.token,
                                            userId: widget.user.id,
                                          );
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: widget.id != null
                                                ? 'Berhasil mengubah kelas'
                                                : 'Berhasil mendaftar kelas',
                                          );
                                        } on HttpException catch (err) {
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
                                                ? 'Gagal mengubah kelas. Silakan coba lagi.'
                                                : 'Gagal membuat kelas. Silakan coba lagi.',
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
