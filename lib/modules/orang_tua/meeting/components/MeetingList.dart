import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/models/usulanMeeting.dart';
import 'package:skripsi_rinaldo/modules/guru/usulan-meeting-chosen/UsulanMeetingChosen.dart';

class MeetingGuruList extends StatelessWidget {
  final bool first;
  final bool last;
  final int idx;
  final User user;
  final UsulanMeeting meeting;

  MeetingGuruList({
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
        height: 150,
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(7),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => UsulanMeetingChosen(meeting.name, meeting.id),
              ),
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
                        meeting.name,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                    ],
                  ),
                  Text(
                    meeting.className,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "${DateFormat('dd MMMM yyyy HH:mm').format(meeting.start)} - ${DateFormat('dd MMMM yyyy HH:mm').format(meeting.end)}",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Link : ${meeting.link}",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
