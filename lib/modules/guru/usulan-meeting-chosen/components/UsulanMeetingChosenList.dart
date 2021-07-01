import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:skripsi_rinaldo/models/ortu.dart';
import 'package:skripsi_rinaldo/models/user.dart';

class UsulanMeetingChosenList extends StatelessWidget {
  final Ortu ortu;
  final User user;
  final int classId;

  UsulanMeetingChosenList(this.ortu, this.user, this.classId);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  ortu.avatar,
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: MediaQuery.of(context).size.width - 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ortu.name),
                Text('Murid : ${ortu.studentName}'),
                ortu.chosenDate != null
                    ? Text('Tanggal : ${DateFormat('yyyy-MM-dd HH:mm').format(ortu.chosenDate)}')
                    : Text(
                        'Belum memilih tanggal',
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
