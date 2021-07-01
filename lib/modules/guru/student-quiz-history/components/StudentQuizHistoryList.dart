import 'package:flutter/material.dart';

import 'package:skripsi_rinaldo/models/history.dart';
import 'package:skripsi_rinaldo/models/user.dart';

class StudentQuizHistoryList extends StatelessWidget {
  final History history;
  final User user;

  StudentQuizHistoryList(this.history, this.user);

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
                  history.userAvatar,
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
                Text(history.userName),
                Text('Durasi : ${history.durasi} menit'),
                Text('Nilai : ${history.nilai}'),
                Text('Status : ${history.status}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
