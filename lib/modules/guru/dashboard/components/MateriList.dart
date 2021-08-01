import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_rinaldo/models/dashboardMateri.dart';
import 'package:skripsi_rinaldo/utils/ExpandedCard.dart';

class MateriList extends StatefulWidget {
  final DashboardMateri materi;
  const MateriList(this.materi, {Key key}) : super(key: key);

  @override
  _MateriListState createState() => _MateriListState();
}

class _MateriListState extends State<MateriList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.transparent,
      child: ExpandedCardList(
        animationDuration: new Duration(milliseconds: 400),
        expansionCallback: (int index, bool isExpanded) => setState(() => _expanded = !_expanded),
        expandedHeaderPadding: EdgeInsets.symmetric(vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 1.0),
              spreadRadius: 0.3,
              blurRadius: 3.0,
            )
          ],
        ),
        children: [
          ExpandedCard(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.materi.kelas.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                    Text(
                      '${DateFormat('dd MMMM yyyy').format(widget.materi.kelas.start)} - ${DateFormat('dd MMMM yyyy').format(widget.materi.kelas.end)}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12),
                      softWrap: true,
                    ),
                  ],
                ),
              );
            },
            isExpanded: _expanded,
            canTapOnHeader: true,
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: generateMateri(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> generateMateri() {
    List<Widget> res = [];
    int counter = 1;
    widget.materi.materi.forEach((item) {
      res.add(Text('$counter. ${item.name}'));
      counter++;
    });
    res.add(SizedBox(height: 15));
    res.add(Text(
      'Silahkan lihat pada menu materi untuk selengkapnya.',
      style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic, fontSize: 10),
    ));
    return res;
  }
}
