import 'package:flutter/material.dart';
import 'package:skripsi_rinaldo/utils/ExpandedCard.dart';

class HistoryListMurid extends StatefulWidget {
  final bool first;
  final bool last;
  final String namaMateri;
  final String durasi;
  final int nilai;
  final String kelulusan;

  HistoryListMurid({
    @required this.first,
    @required this.last,
    @required this.namaMateri,
    @required this.durasi,
    @required this.nilai,
    @required this.kelulusan,
  });

  @override
  _HistoryListMuridState createState() => _HistoryListMuridState();
}

class _HistoryListMuridState extends State<HistoryListMurid> {
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
              Colors.amber,
              Colors.amber[400],
              Colors.amber[300],
              Colors.amber[200],
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
                  0: FlexColumnWidth(10),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(11),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Durasi Pengerjaan'),
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
                          child: Text('${widget.durasi} menit'),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Nilai'),
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
                          child: Text('${widget.nilai}'),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Status Kelulusan'),
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
                          child: Text('${widget.kelulusan}'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
