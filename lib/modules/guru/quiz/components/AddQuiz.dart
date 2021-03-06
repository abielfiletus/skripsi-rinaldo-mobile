import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/providers/quiz.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class AddGuruQuizDialog extends StatefulWidget {
  final User user;
  final int id;
  final int idx;
  final int materiIdx;
  final int materiId;
  final int classId;

  AddGuruQuizDialog({
    @required this.user,
    @required this.materiIdx,
    @required this.materiId,
    @required this.classId,
    this.idx,
    this.id,
  });

  @override
  _AddGuruQuizDialogState createState() => _AddGuruQuizDialogState();
}

class _AddGuruQuizDialogState extends State<AddGuruQuizDialog> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController nilaiMinController = new TextEditingController();

  DateTime _tanggalKumpul;
  bool _isLoading = true;
  bool _buttonIsLoading = false;

  @override
  void initState() {
    if (widget.id != null) {
      Provider.of<QuizProvider>(context, listen: false).getDetailQuiz(widget.user.token, widget.id).then(
        (_) {
          final data = Provider.of<QuizProvider>(context, listen: false).detail;
          setState(() {
            _isLoading = false;
            nameController.text = data.name;
            nilaiMinController.text = data.nilaiLulus.toString();
            _tanggalKumpul = DateFormat('yyyy-MM-dd').parse(data.tanggalKumpul);
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
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.id != null ? 'Ubah Quiz' : 'Tambah Quiz Baru',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: FormBuilder(
                      key: globalFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormBuilderTextField(
                            name: 'name',
                            controller: nameController,
                            textCapitalization: TextCapitalization.words,
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
                            name: 'tanggal kumpul',
                            initialValue: _tanggalKumpul,
                            inputType: InputType.date,
                            firstDate: DateTime(1700),
                            lastDate: DateTime(new DateTime.now().year, 12),
                            format: DateFormat('yyyy-MM-dd'),
                            decoration: InputDecoration(
                              labelText: 'Tanggal Kumpul',
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
                              () => _tanggalKumpul = value,
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
                                    child: Row(
                                      children: [
                                        Icon(Icons.cancel, color: Colors.white),
                                        SizedBox(width: 5),
                                        Text('Cancel',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
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
                                        : Row(
                                            children: [
                                              Icon(Icons.send, color: Colors.white),
                                              SizedBox(width: 5),
                                              Text('Submit',
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                  ),
                                  onTap: () async {
                                    if (validateAndSave()) {
                                      setState(() => _buttonIsLoading = true);

                                      try {
                                        if (widget.id != null) {
                                          await Provider.of<QuizProvider>(context, listen: false).updateQuiz(
                                            token: widget.user.token,
                                            id: widget.id,
                                            name: nameController.text,
                                            classMateriId: widget.materiId,
                                            nilaiLulus: nilaiMinController.text,
                                            tanggalKumpul: DateFormat('yyyy-MM-dd').format(_tanggalKumpul),
                                          );
                                        } else {
                                          await Provider.of<QuizProvider>(context, listen: false).createQuiz(
                                            token: widget.user.token,
                                            name: nameController.text,
                                            classMateriId: widget.materiId,
                                            nilaiLulus: nilaiMinController.text,
                                            tanggalKumpul: DateFormat('yyyy-MM-dd').format(_tanggalKumpul),
                                          );
                                        }
                                        setState(() => _buttonIsLoading = false);
                                        await Provider.of<MateriProvider>(context, listen: false).guruGetList(
                                          token: widget.user.token,
                                          classId: widget.classId.toString(),
                                        );
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                          msg: widget.id != null ? 'Berhasil mengubah quiz' : 'Berhasil membuat quiz',
                                        );
                                      } on HttpException catch (err) {
                                        Fluttertoast.showToast(
                                          msg: err.toString(),
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                        );
                                        setState(() => _buttonIsLoading = false);
                                      } catch (err) {
                                        setState(() => _buttonIsLoading = false);
                                        print(err);
                                        Fluttertoast.showToast(
                                          msg: widget.id != null
                                              ? 'Gagal mengubah quiz. Silakan coba lagi.'
                                              : 'Gagal membuat quiz. Silakan coba lagi.',
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
