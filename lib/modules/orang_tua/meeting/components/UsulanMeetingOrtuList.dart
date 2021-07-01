import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/models/meeting.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/meeting/components/UsulanMeetingChosen.dart';

class UsulanMeetingOrtuList extends StatelessWidget {
  final bool first;
  final bool last;
  final int idx;
  final User user;
  final Meeting meeting;

  UsulanMeetingOrtuList({
    @required this.first,
    @required this.last,
    @required this.idx,
    @required this.user,
    @required this.meeting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: first ? 0 : 5, bottom: last ? 0 : 5),
      child: Container(
        height: 200,
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(7),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => UsulanOrtuMeetingChosen(meeting)),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(7)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meeting.name,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  Text(
                    meeting.className,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "${DateFormat('dd MMMM yyyy HH:mm').format(meeting.startDate)} - ${DateFormat('dd MMMM yyyy HH:mm').format(meeting.endDate)}",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Deskripsi :',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    meeting.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Klik untuk melihat selengkapnya...',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
