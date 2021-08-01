import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_rinaldo/models/Kelas.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/kelas/components/AddClass.dart';
import 'package:skripsi_rinaldo/modules/guru/kelas/components/DeleteClass.dart';
import 'package:skripsi_rinaldo/modules/guru/materi/Materi.dart';
import 'package:skripsi_rinaldo/modules/guru/student/Student.dart';

class KelasGuruList extends StatefulWidget {
  final bool first;
  final bool last;
  final int idx;
  final User user;
  final Kelas kelas;

  KelasGuruList({
    @required this.first,
    @required this.last,
    @required this.idx,
    @required this.user,
    @required this.kelas,
  });

  @override
  _KelasGuruListState createState() => _KelasGuruListState();
}

class _KelasGuruListState extends State<KelasGuruList> {
  final rand = new Random().nextInt(9);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.first ? 0 : 5, bottom: widget.last ? 0 : 5),
      child: Container(
        height: 200,
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(7),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => MateriGuruPage(widget.kelas.name, widget.kelas.id),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/class_bg_$rand.jpg'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0.0, 2.0),
                    spreadRadius: .5,
                    blurRadius: 5.0,
                  )
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(7)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.kelas.name,
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          child: PopupMenuButton(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            itemBuilder: (BuildContext ctx) => ['Ubah', 'Murid', 'Hapus']
                                .map((item) => PopupMenuItem(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                      child: Row(
                                        children: [
                                          item == 'Ubah'
                                              ? Icon(Icons.edit)
                                              : item == 'Hapus'
                                                  ? Icon(Icons.delete)
                                                  : Icon(Icons.person),
                                          SizedBox(width: 5),
                                          Text(item, style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                      value: item,
                                    ))
                                .toList(),
                            child: Icon(Icons.more_horiz, color: Colors.white),
                            onSelected: (val) {
                              if (val == 'Ubah') {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (ctx, _, __) => AddGuruClassDialog(
                                      user: widget.user,
                                      id: widget.kelas.id,
                                      idx: widget.idx,
                                    ),
                                  ),
                                );
                              } else if (val == 'Hapus') {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (ctx, _, __) => DeleteClassDialog(
                                      name: widget.kelas.name,
                                      id: widget.kelas.id,
                                      token: widget.user.token,
                                      userId: widget.user.id,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (ctx) => StudentPage(widget.user, widget.kelas)),
                                );
                              }
                            },
                            tooltip: 'lainnya',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.kelas.code,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "${DateFormat('dd MMMM yyyy').format(widget.kelas.start)} - ${DateFormat('dd MMMM yyyy').format(widget.kelas.end)}",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 70),
                    Text(
                      'Nilai Minimum : ${widget.kelas.nilaiMinimum.toString()} poin',
                      style: TextStyle(color: Colors.white),
                      softWrap: true,
                    ),
                    Row(
                      children: [
                        Row(children: [
                          Icon(Icons.book_rounded, color: Colors.white),
                          SizedBox(width: 10),
                          Text(widget.kelas.materiTotal, style: TextStyle(color: Colors.white))
                        ]),
                        SizedBox(width: 20),
                        Row(children: [
                          Icon(Icons.person, color: Colors.white),
                          SizedBox(width: 10),
                          Text(widget.kelas.studentTotal, style: TextStyle(color: Colors.white))
                        ]),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
