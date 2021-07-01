import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class AddClassMuridDialog extends StatefulWidget {
  final User user;

  AddClassMuridDialog({@required this.user});

  @override
  _AddClassMuridDialogState createState() => _AddClassMuridDialogState();
}

class _AddClassMuridDialogState extends State<AddClassMuridDialog> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  TextEditingController classCodeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Kelas Baru'),
      content: Container(
        height: 130,
        child: FormBuilder(
          key: globalFormKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'code',
                controller: classCodeController,
                decoration: InputDecoration(
                  labelText: 'Class Code',
                  hintText: 'Contoh: AB2-CDE-F2H',
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
                        child: Text('Submit', style: TextStyle(color: Colors.white)),
                      ),
                      onTap: () async {
                        if (validateAndSave()) {
                          try {
                            await Provider.of<KelasProvider>(
                              context,
                              listen: false,
                            ).registerClass(
                              token: widget.user.token,
                              code: classCodeController.text,
                              userId: widget.user.id,
                            );
                            Provider.of<KelasProvider>(context, listen: false)
                                .getList(token: widget.user.token, userId: widget.user.id)
                                .then((_) {
                              final data = Provider.of<KelasProvider>(context, listen: false).list;

                              if (data.length > 0) {
                                Provider.of<MateriProvider>(context, listen: false).getList(token: widget.user.token, userId: widget.user.id.toString());
                              }
                              Navigator.pop(context);
                              Fluttertoast.showToast(msg: 'Berhasil mendaftar kelas');
                            });
                          } on HttpException catch (err) {
                            Fluttertoast.showToast(
                              msg: err.toString(),
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          } catch (err) {
                            print(err);
                            Fluttertoast.showToast(
                              msg: 'Gagal melakukan pendaftaran. Silakan coba lagi.',
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
