import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/models/usulanMeeting.dart';
import 'package:skripsi_rinaldo/modules/guru/usulan-meeting-chosen/components/UsulanMeetingChosenList.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/BottomNavigation.dart';
import 'package:skripsi_rinaldo/providers/Ortu.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';

class MeetingDetail extends StatefulWidget {
  final UsulanMeeting meeting;

  MeetingDetail(this.meeting);

  @override
  _UsulanMeetingChosenState createState() => _UsulanMeetingChosenState();
}

class _UsulanMeetingChosenState extends State<MeetingDetail> {
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
      bottomNavigationBar: BottomNavigationOrtu('home'),
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
                            'Belum ada peserta di meeting ini.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          width: double.infinity),
            ),
          ),
        ),
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
        'Tanggal Meeting :',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      SizedBox(height: 5),
      Text(
        '${DateFormat('dd MMMM yyyy').format(widget.meeting.start)} - ${DateFormat('dd MMMM yyyy').format(widget.meeting.end)}',
      ),
      SizedBox(height: 20),
      Text(
        'Waktu Meeting :',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      SizedBox(height: 5),
      Text(
        '${DateFormat('HH:mm').format(widget.meeting.start)} - ${DateFormat('HH:mm').format(widget.meeting.end)}',
      ),
      SizedBox(height: 20),
      Text(
        'Link Meeting :',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      SizedBox(height: 5),
      SelectableText('${widget.meeting.link}'),
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
      _widget.add(UsulanMeetingChosenList(
        item,
        _user,
        widget.meeting.id,
        showDate: false,
      ));
      if (item.userId == _user.id && item.chosenDate != null) setState(() => _alreadyRegis = true);
    }

    return _widget;
  }
}
