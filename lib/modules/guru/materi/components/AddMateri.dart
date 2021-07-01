import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/materi.dart';

import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/utils/FormBuilderFilePicker.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class AddGuruMateriDialog extends StatefulWidget {
  final User user;
  final int idx;
  final int classId;
  final int materiId;
  final String className;

  AddGuruMateriDialog({
    @required this.user,
    @required this.classId,
    @required this.className,
    this.materiId,
    this.idx,
  });

  @override
  _AddGuruMateriDialogState createState() => _AddGuruMateriDialogState();
}

class _AddGuruMateriDialogState extends State<AddGuruMateriDialog> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  TextEditingController nameController = new TextEditingController();

  String _materi;
  Materi materi;
  bool _isLoading = true;
  bool _buttonIsLoading = false;

  @override
  void initState() {
    if (widget.idx != null) {
      materi = Provider.of<MateriProvider>(context, listen: false).detail(widget.idx);
      setState(() {
        _isLoading = false;
        nameController.text = materi.name;
      });
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
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.idx != null ? 'Ubah Materi' : 'Tambah Materi Baru'),
                  SizedBox(height: 15),
                  FormBuilder(
                    key: globalFormKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'name',
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Name',
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
                        FormBuilderFilePicker(
                          name: 'materi',
                          maxFiles: 1,
                          previewImages: true,
                          selector: Row(
                            children: <Widget>[
                              Icon(Icons.file_upload),
                              Text('Upload'),
                            ],
                          ),
                          allowCompression: true,
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                          onChanged: (val) => setState(() => _materi = val[0].path),
                          decoration: InputDecoration(
                            labelText: 'Materi',
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
                                      if (widget.idx != null) {
                                        await Provider.of<MateriProvider>(
                                          context,
                                          listen: false,
                                        ).update(
                                          idx: widget.idx,
                                          id: widget.materiId,
                                          token: widget.user.token,
                                          classId: widget.classId,
                                          materi: _materi,
                                          name: nameController.text,
                                          className: widget.className,
                                        );
                                      } else {
                                        await Provider.of<MateriProvider>(
                                          context,
                                          listen: false,
                                        ).create(
                                          token: widget.user.token,
                                          classId: widget.classId,
                                          materi: _materi,
                                          name: nameController.text,
                                          className: widget.className,
                                        );
                                      }
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                        msg: widget.idx != null ? 'Berhasil mengubah materi.' : 'Berhasil membuat materi.',
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
                                        msg: widget.idx != null
                                            ? 'Gagal mengubah materi. Silakan coba lagi.'
                                            : 'Gagal membuat materi. Silakan coba lagi.',
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
                ],
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
