import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:skripsi_rinaldo/models/soal.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/quiz/components/AddSoal.dart';
import 'package:skripsi_rinaldo/modules/guru/quiz/components/DeleteSoal.dart';

class QuizListGuru extends StatelessWidget {
  final Soal quiz;
  final int idx;
  final User user;

  QuizListGuru(this.quiz, this.idx, this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0.0, 2.0),
            spreadRadius: .5,
            blurRadius: 3.0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${idx + 1}. ${quiz.soal}',
            style: TextStyle(fontSize: 17),
          ),
          FormBuilderRadioGroup(
            name: 'question',
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(0),
            ),
            enabled: false,
            initialValue: quiz.jawabanBenar,
            orientation: OptionsOrientation.vertical,
            options: [
              FormBuilderFieldOption(
                value: 'a',
                child: Text('${quiz.jawabanA}'),
              ),
              FormBuilderFieldOption(
                value: 'b',
                child: Text('${quiz.jawabanB}'),
              ),
              FormBuilderFieldOption(
                value: 'c',
                child: Text('${quiz.jawabanC}'),
              ),
              FormBuilderFieldOption(
                value: 'd',
                child: Text('${quiz.jawabanD}'),
              ),
              FormBuilderFieldOption(
                value: 'e',
                child: Text('${quiz.jawabanE}'),
              ),
            ],
          ),
          Row(
            children: [
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (ctx, _, __) => AddGuruSoalDialog(
                          quizId: quiz.classQuizId,
                          user: user,
                          id: quiz.id,
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.amber[400]),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 10)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 5),
                      Text("Ubah", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (ctx, _, __) => DeleteGuruSoalDialog(
                          user: user,
                          idx: idx,
                          quizId: quiz.classQuizId,
                          id: quiz.id,
                          soal: quiz.soal,
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red[400]),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 10)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 5),
                      Text("Hapus", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
