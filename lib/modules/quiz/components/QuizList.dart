import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/soal.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';
import 'package:skripsi_rinaldo/providers/quiz.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class QuizList extends StatefulWidget {
  final String token;
  final int classQuizId;
  final int classId;
  final int userId;
  final int classMateriId;

  QuizList({
    @required this.token,
    @required this.classQuizId,
    @required this.classId,
    @required this.classMateriId,
    @required this.userId,
  });

  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  List<Map<String, dynamic>> _answer = [];

  int secondsCounter;
  bool _isCoreLoading = true;
  bool _isLoading = false;
  bool flag = true;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;

  @override
  void initState() {
    super.initState();
    Provider.of<QuizProvider>(context, listen: false)
        .getList(
      token: widget.token,
      quizId: widget.classQuizId.toString(),
    )
        .then((_) {
      final quiz = Provider.of<QuizProvider>(context, listen: false).list;
      for (var i = 0; i < quiz.length; i++) {
        setState(
          () => _answer.add({
            'id': quiz[i].id,
            'jawaban': '',
          }),
        );
      }
      setState(() {
        _isCoreLoading = false;
        timerStream = stopWatchStream();
        timerSubscription = timerStream.listen((int newTick) {
          setState(() {
            secondsCounter = newTick;
            hoursStr = ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
            minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
            secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timerSubscription.cancel();
    timerStream = null;
  }

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<QuizProvider>(context).list;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 5, bottom: 15),
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.amber,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 1.0),
                spreadRadius: 0.3,
                blurRadius: 3.0,
              )
            ],
          ),
          height: 34,
          width: 70,
          child: Text(
            "$hoursStr:$minutesStr:$secondsStr",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: _isCoreLoading
              ? Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator(), SizedBox(height: 10), Text('Please Wait...')],
                  ),
                )
              : SingleChildScrollView(
                  child: FormBuilder(
                    key: globalFormKey,
                    child: Column(
                      children: [
                        ...renderList(quiz),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    highlightColor: Colors.black12,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 15.0,
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: _isLoading
                                            ? Text(
                                                "Please Wait...",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            : Text(
                                                "Submit",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                      ),
                                    ),
                                    onTap: () async {
                                      if (validateAndSave()) {
                                        try {
                                          await Provider.of<QuizProvider>(
                                            context,
                                            listen: false,
                                          ).submitAnswer(
                                            classId: widget.classId.toString(),
                                            classMateriId: widget.classMateriId.toString(),
                                            classQuizId: widget.classQuizId.toString(),
                                            durasi: secondsCounter.toString(),
                                            jawaban: _answer,
                                            token: widget.token,
                                            userId: widget.userId.toString(),
                                          );
                                          Provider.of<KelasProvider>(context, listen: false)
                                              .getList(token: widget.token, userId: widget.userId)
                                              .then((_) {
                                            final data = Provider.of<KelasProvider>(context, listen: false).list;

                                            if (data.length > 0) {
                                              Provider.of<MateriProvider>(context, listen: false)
                                                  .getList(token: widget.token, userId: widget.userId.toString());
                                            }
                                            Navigator.pop(context);
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
                                            msg: 'Gagal submit jawaban. Silakan coba lagi.',
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        )
      ],
    );
  }

  List<Widget> renderList(List<Soal> quiz) {
    List<Widget> _list = [];

    for (var i = 0; i < quiz.length; i++) {
      _list.add(
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${i + 1}. ${quiz[i].soal}',
                style: TextStyle(fontSize: 17),
              ),
              FormBuilderRadioGroup(
                name: 'question',
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                ),
                orientation: OptionsOrientation.vertical,
                options: [
                  FormBuilderFieldOption(
                    value: 'a',
                    child: Text('${quiz[i].jawabanA}'),
                  ),
                  FormBuilderFieldOption(
                    value: 'b',
                    child: Text('${quiz[i].jawabanB}'),
                  ),
                  FormBuilderFieldOption(
                    value: 'c',
                    child: Text('${quiz[i].jawabanC}'),
                  ),
                  FormBuilderFieldOption(
                    value: 'd',
                    child: Text('${quiz[i].jawabanD}'),
                  ),
                  FormBuilderFieldOption(
                    value: 'e',
                    child: Text('${quiz[i].jawabanE}'),
                  ),
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.compose([FormBuilderValidators.required(context, errorText: '')]),
                onChanged: (val) => _answer[i]['jawaban'] = val,
              )
            ],
          ),
        ),
      );
    }
    return _list;
  }

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
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
