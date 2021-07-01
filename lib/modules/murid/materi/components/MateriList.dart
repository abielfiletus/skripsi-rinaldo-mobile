import 'package:flutter/material.dart';

import 'package:skripsi_rinaldo/utils/ExpandedCard.dart';
import 'package:skripsi_rinaldo/utils/PdfViewer.dart';
import 'package:skripsi_rinaldo/modules/murid/quiz/Quiz.dart';

class MateriMuridList extends StatefulWidget {
  final bool first;
  final bool last;
  final String namaMateri;
  final String tanggalKumpul;
  final int quizId;
  final int classId;
  final int materiId;
  final int userId;
  final String status;
  final String path;
  final String historyId;
  final String token;

  MateriMuridList({
    @required this.token,
    @required this.first,
    @required this.last,
    @required this.namaMateri,
    @required this.tanggalKumpul,
    @required this.status,
    @required this.path,
    @required this.classId,
    @required this.materiId,
    @required this.userId,
    @required this.historyId,
    this.quizId,
  });

  @override
  _MateriMuridListState createState() => _MateriMuridListState();
}

class _MateriMuridListState extends State<MateriMuridList> {
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
                  widget.namaMateri,
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
              child: Table(
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
                          child: Text('${widget.tanggalKumpul}'),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Status'),
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
                          child: Text('${widget.status}'),
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
                          child: Text('Baca Materi'),
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
                                        path: widget.path,
                                        fileName: widget.namaMateri,
                                        token: widget.token,
                                        classId: widget.classId.toString(),
                                        materiId: widget.materiId.toString(),
                                        quizId: widget.quizId.toString(),
                                        userId: widget.userId.toString(),
                                        historyId: widget.historyId,
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
                          child: widget.quizId == null
                              ? Text(
                                  'Tidak ada',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                )
                              : Container(
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
                                            builder: (ctx) => QuizMuridPage(
                                              classQuizId: widget.quizId,
                                              classId: widget.classId,
                                              classMateriId: widget.materiId,
                                              userId: widget.userId,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
