import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/quiz.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class AddGuruSoalDialog extends StatefulWidget {
  final User user;
  final int quizId;
  final int id;

  AddGuruSoalDialog({
    @required this.user,
    @required this.quizId,
    this.id,
  });

  @override
  _AddGuruSoalDialogState createState() => _AddGuruSoalDialogState();
}

class _AddGuruSoalDialogState extends State<AddGuruSoalDialog> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  TextEditingController soalController = new TextEditingController();
  TextEditingController jawabanAController = new TextEditingController();
  TextEditingController jawabanBController = new TextEditingController();
  TextEditingController jawabanCController = new TextEditingController();
  TextEditingController jawabanDController = new TextEditingController();
  TextEditingController jawabanEController = new TextEditingController();
  TextEditingController jawabanBenarController = new TextEditingController(text: 'a');

  bool _isLoading = true;
  bool _buttonIsLoading = false;

  @override
  void initState() {
    if (widget.id != null) {
      Provider.of<QuizProvider>(context, listen: false).getDetailSoal(widget.user.token, widget.id).then(
        (_) {
          final data = Provider.of<QuizProvider>(context, listen: false).detailSoal;
          setState(() {
            _isLoading = false;
            soalController.text = data.soal;
            jawabanAController.text = data.jawabanA;
            jawabanBController.text = data.jawabanB;
            jawabanCController.text = data.jawabanC;
            jawabanDController.text = data.jawabanD;
            jawabanEController.text = data.jawabanE;
            jawabanBenarController.text = data.jawabanBenar;
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
                padding: EdgeInsets.all(40),
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
                              name: 'soal',
                              controller: soalController,
                              textInputAction: TextInputAction.next,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Soal',
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
                              name: 'jawaban a',
                              controller: jawabanAController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Jawaban A',
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
                              name: 'jawaban b',
                              controller: jawabanBController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Jawaban B',
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
                              name: 'jawaban c',
                              controller: jawabanCController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Jawaban C',
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
                              name: 'jawaban d',
                              controller: jawabanDController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Jawaban D',
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
                              name: 'jawaban e',
                              controller: jawabanEController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Jawaban E',
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
                            FormBuilderDropdown(
                              name: 'jawaban benar',
                              initialValue: jawabanBenarController.text.isNotEmpty ? jawabanBenarController.text : 'a',
                              decoration: InputDecoration(
                                labelText: 'Jawaban Benar',
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
                              items: [
                                DropdownMenuItem(
                                  child: Text('Jawaban A'),
                                  value: 'a',
                                ),
                                DropdownMenuItem(
                                  child: Text('Jawaban B'),
                                  value: 'b',
                                ),
                                DropdownMenuItem(
                                  child: Text('Jawaban C'),
                                  value: 'c',
                                ),
                                DropdownMenuItem(
                                  child: Text('Jawaban D'),
                                  value: 'd',
                                ),
                                DropdownMenuItem(
                                  child: Text('Jawaban E'),
                                  value: 'e',
                                ),
                              ],
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context, errorText: 'harus terisi'),
                              ]),
                              onChanged: (val) => setState(() => jawabanBenarController.text = val),
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
                                            await Provider.of<QuizProvider>(context, listen: false).updateSoal(
                                              token: widget.user.token,
                                              id: widget.id,
                                              classQuizId: widget.quizId,
                                              jawabanA: jawabanAController.text,
                                              jawabanB: jawabanBController.text,
                                              jawabanC: jawabanCController.text,
                                              jawabanD: jawabanDController.text,
                                              jawabanE: jawabanEController.text,
                                              jawabanBenar: jawabanBenarController.text,
                                              soal: soalController.text,
                                            );
                                          } else {
                                            await Provider.of<QuizProvider>(context, listen: false).createSoal(
                                              token: widget.user.token,
                                              classQuizId: widget.quizId,
                                              jawabanA: jawabanAController.text,
                                              jawabanB: jawabanBController.text,
                                              jawabanC: jawabanCController.text,
                                              jawabanD: jawabanDController.text,
                                              jawabanE: jawabanEController.text,
                                              jawabanBenar: jawabanBenarController.text,
                                              soal: soalController.text,
                                            );
                                          }
                                          setState(() => _buttonIsLoading = false);
                                          await Provider.of<QuizProvider>(context, listen: false).getGuruList(
                                            token: widget.user.token,
                                            quizId: widget.quizId.toString(),
                                          );
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: widget.id != null ? 'Berhasil mengubah soal' : 'Berhasil membuat soal',
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
                                                ? 'Gagal mengubah soal. Silakan coba lagi.'
                                                : 'Gagal membuat soal. Silakan coba lagi.',
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
