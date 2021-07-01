import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:skripsi_rinaldo/models/meeting.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/meeting/components/AddUsulanMeeting.dart';
import 'package:skripsi_rinaldo/modules/guru/meeting/components/DeleteMeeting.dart';
import 'package:skripsi_rinaldo/modules/guru/usulan-meeting-chosen/UsulanMeetingChosen.dart';

class UsulanMeetingGuruList extends StatelessWidget {
  final bool first;
  final bool last;
  final int idx;
  final User user;
  final Meeting meeting;

  UsulanMeetingGuruList({
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
        height: 160,
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
                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        child: PopupMenuButton(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          itemBuilder: (BuildContext ctx) => ['Ubah', 'Hapus']
                              .map((item) => PopupMenuItem(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                    child: Row(
                                      children: [
                                        item == 'Ubah' ? Icon(Icons.edit) : Icon(Icons.delete),
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
                                  pageBuilder: (ctx, _, __) => AddGuruUsulanMeetingDialog(
                                    user: user,
                                    id: meeting.id,
                                    idx: idx,
                                    meeting: meeting,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (ctx, _, __) => DeleteGuruMeetingDialog(
                                    user: user,
                                    id: meeting.id,
                                    meeting: meeting,
                                  ),
                                ),
                              );
                            }
                          },
                          tooltip: 'lainnya',
                        ),
                      ),
                    ],
                  ),
                  Text(
                    meeting.className,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "${DateFormat('dd MMMM yyyy HH:mm').format(meeting.startDate)} - ${DateFormat('dd MMMM yyyy HH:mm').format(meeting.endDate)}",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 50),
                  Row(children: [
                    Icon(Icons.person, color: Colors.white),
                    SizedBox(width: 10),
                    Text("${meeting.choose} / ${meeting.notChoose + meeting.choose}", style: TextStyle(color: Colors.white))
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
