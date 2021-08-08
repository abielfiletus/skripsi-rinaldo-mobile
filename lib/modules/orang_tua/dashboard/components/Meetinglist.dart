import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_rinaldo/models/usulanMeeting.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/dashboard/components/MeetingDetail.dart';

class MeetingList extends StatelessWidget {
  final UsulanMeeting meeting;
  const MeetingList(this.meeting, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        color: Colors.white,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(7),
            splashColor: Colors.black,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => MeetingDetail(meeting)),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meeting.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  if (meeting.className != null)
                    Text(
                      meeting.className,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  Text(
                    "${DateFormat('dd MMMM yyyy HH:mm').format(meeting.start)} - ${DateFormat('dd MMMM yyyy HH:mm').format(meeting.end)}",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "Link : ${meeting.link}",
                    style: TextStyle(fontSize: 13),
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
