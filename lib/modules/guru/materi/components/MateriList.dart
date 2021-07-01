import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_rinaldo/models/materi.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/materi/components/AddMateri.dart';
import 'package:skripsi_rinaldo/modules/guru/materi/components/DeleteMateri.dart';
import 'package:skripsi_rinaldo/modules/guru/quiz/components/AddQuiz.dart';
import 'package:skripsi_rinaldo/modules/guru/quiz/components/DeleteQuiz.dart';
import 'package:skripsi_rinaldo/modules/guru/student-quiz-history/StudentQuizHistory.dart';

import 'package:skripsi_rinaldo/utils/ExpandedCard.dart';
import 'package:skripsi_rinaldo/utils/PdfViewer.dart';
import 'package:skripsi_rinaldo/modules/guru/quiz/Quiz.dart';

class MateriGuruList extends StatefulWidget {
  final bool first;
  final bool last;
  final Materi materi;
  final User user;
  final String token;
  final int idx;

  MateriGuruList({
    @required this.token,
    @required this.first,
    @required this.last,
    @required this.user,
    @required this.materi,
    @required this.idx,
  });

  @override
  _MateriGuruListState createState() => _MateriGuruListState();
}

class _MateriGuruListState extends State<MateriGuruList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.first ? 0 : 5, bottom: widget.last ? 0 : 5),
      child: ExpandedCardList(
        animationDuration: new Duration(milliseconds: 400),
        expansionCallback: (int index, bool isExpanded) => setState(() => _expanded = !_expanded),
        expandedHeaderPadding: EdgeInsets.symmetric(vertical: 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: [
              Colors.green,
              Colors.green[400],
              Colors.green[300],
              Colors.green[200],
            ],
          ),
        ),
        children: [
          ExpandedCard(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  widget.materi.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  softWrap: true,
                ),
              );
            },
            isExpanded: _expanded,
            canTapOnHeader: true,
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(8),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(14),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text('Tanggal Kumpul'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(':'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                widget.materi.tanggalKumpul == null
                                    ? '-'
                                    : DateFormat('dd MMMM yyyy')
                                        .format(DateFormat('yyyy-MM-dd').parse(widget.materi.tanggalKumpul)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text('Lihat Materi'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(':'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Material(
                                  child: InkWell(
                                    child: Icon(Icons.picture_as_pdf, color: Colors.red[800]),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => PDFViewer(
                                            path: widget.materi.path,
                                            fileName: widget.materi.name,
                                            token: widget.token,
                                            classId: widget.materi.classId.toString(),
                                            materiId: widget.materi.id.toString(),
                                            userId: widget.user.id.toString(),
                                            historyId: widget.materi.historyId,
                                            updateHistory: false,
                                            timer: false,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text('Quiz'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(':'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: widget.materi.quiz != null && widget.materi.quiz.id != null
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          child: Image.asset(
                                            'assets/images/quiz.png',
                                            width: 32,
                                            height: 32,
                                            color: Colors.green[800],
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (ctx) => QuizGuruPage(
                                                  widget.materi.name,
                                                  widget.materi.quiz.id,
                                                  widget.user,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Tidak ada',
                                      style: TextStyle(fontStyle: FontStyle.italic),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        widget.materi.quiz != null && widget.materi.quiz.id != null
                            ? Row(
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
                                            pageBuilder: (ctx, _, __) => StudentQuizHistoryPage(
                                              widget.materi.className,
                                              widget.materi.id,
                                              widget.user,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[400]),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                        padding:
                                            MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 10)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.remove_red_eye),
                                          SizedBox(width: 5),
                                          Text("Lihat Pengerjaan Quiz", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                            pageBuilder: (ctx, _, __) => AddGuruQuizDialog(
                                              id: widget.materi.quiz.id,
                                              user: widget.user,
                                              materiIdx: widget.idx,
                                              materiId: widget.materi.id,
                                              classId: widget.materi.classId,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan[400]),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                        padding:
                                            MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 10)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 5),
                                          Text("Ubah Quiz", style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (ctx, _, __) => AddGuruQuizDialog(
                                          user: widget.user,
                                          materiIdx: widget.idx,
                                          materiId: widget.materi.id,
                                          classId: widget.materi.classId,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan[400]),
                                    shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 10)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add),
                                      SizedBox(width: 5),
                                      Text("Tambah Quiz", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                        SizedBox(width: 10),
                        widget.materi.quiz != null && widget.materi.quiz.id != null
                            ? Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (ctx, _, __) => DeleteGuruQuizDialog(
                                          user: widget.user,
                                          idx: widget.idx,
                                          classId: widget.materi.classId,
                                          id: widget.materi.quiz.id,
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
                                      Text("Hapus Quiz", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        widget.materi.quiz != null && widget.materi.quiz.id != null ? SizedBox(width: 10) : SizedBox(),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (ctx, _, __) => AddGuruMateriDialog(
                                    classId: widget.materi.classId,
                                    className: widget.materi.className,
                                    user: widget.user,
                                    idx: widget.idx,
                                    materiId: widget.materi.id,
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
                                Text("Ubah Materi", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  pageBuilder: (ctx, _, __) => DeleteGuruMateriDialog(
                                    user: widget.user,
                                    idx: widget.idx,
                                    classId: widget.materi.classId,
                                    id: widget.materi.id,
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
                                Text("Hapus Materi", style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
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
        ],
      ),
    );
  }
}
