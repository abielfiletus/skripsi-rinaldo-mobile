import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/meeting.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/meeting/components/AddUsulanMeeting.dart';

import 'package:skripsi_rinaldo/providers/Ortu.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/guru/usulan-meeting-chosen/components/UsulanMeetingChosenList.dart';

class UsulanOrtuMeetingChosen extends StatefulWidget {
  final Meeting meeting;

  UsulanOrtuMeetingChosen(this.meeting);

  @override
  _UsulanMeetingChosenState createState() => _UsulanMeetingChosenState();
}

class _UsulanMeetingChosenState extends State<UsulanOrtuMeetingChosen> {
  User _user;
  bool _isLoading = true;
  bool _alreadyRegis = false;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<OrtuProvider>(context, listen: false)
        .getList(_user.token, widget.meeting.id)
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final _ortu = Provider.of<OrtuProvider>(context).list;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.meeting.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationOrtu('meeting'),
      body: ChangeNotifierProvider(
        create: (_) => KelasProvider(),
        child: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Container(
              child: _isLoading
                  ? Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('Please Wait...'),
                        ],
                      ),
                    )
                  : _ortu.length > 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: renderList(_ortu),
                        )
                      : Container(
                          child: Text(
                            'Belum ada materi di kelas ini.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          width: double.infinity),
            ),
          ),
        ),
      ),
      floatingActionButton: _alreadyRegis
          ? SizedBox()
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (ctx, _, __) => AddOrtuUsulanMeetingDialog(
                      user: _user,
                      meeting: widget.meeting,
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
    );
  }

  List<Widget> renderList(data) {
    List<Widget> _widget = [
      Text(
        'Nama Meeting :',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      SizedBox(height: 5),
      Text(widget.meeting.name),
      SizedBox(height: 20),
      Text(
        'Deskripsi :',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      SizedBox(height: 5),
      Text(widget.meeting.description),
      SizedBox(height: 20),
      Text(
        'Rentang Waktu Usulan :',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      SizedBox(height: 5),
      Text(
        '${DateFormat('dd MMMM yyyy HH:mm').format(widget.meeting.startDate)} - ${DateFormat('dd MMMM yyyy HH:mm').format(widget.meeting.endDate)}',
      ),
      SizedBox(height: 20),
      Text(
        'Peserta Meeting :',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      SizedBox(height: 5),
    ];

    for (var item in data) {
      _widget.add(UsulanMeetingChosenList(item, _user, widget.meeting.id));
      if (item.userId == _user.id && item.chosenDate != null) setState(() => _alreadyRegis = true);
    }

    return _widget;
  }
}
