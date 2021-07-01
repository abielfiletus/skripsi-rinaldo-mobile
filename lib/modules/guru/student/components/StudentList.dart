import 'package:flutter/material.dart';

import 'package:skripsi_rinaldo/models/student.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/student/components/DeleteStudent.dart';

class StudentList extends StatelessWidget {
  final Student student;
  final User user;
  final int classId;

  StudentList(this.student, this.user, this.classId);

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
                  student.avatar,
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
                Text(student.name),
                Text(student.email),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (ctx, _, __) => DeleteStudentGuruDialog(user: user, student: student, classId: classId),
                ),
              );
            },
            icon: Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
    );
  }
}
