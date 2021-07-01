import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/providers/Ortu.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/guru/usulan-meeting-chosen/components/UsulanMeetingChosenList.dart';

class UsulanMeetingChosen extends StatefulWidget {
  final int usulanMeetingId;
  final String className;

  UsulanMeetingChosen(this.className, this.usulanMeetingId);

  @override
  _UsulanMeetingChosenState createState() => _UsulanMeetingChosenState();
}

class _UsulanMeetingChosenState extends State<UsulanMeetingChosen> {
  User _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<OrtuProvider>(context, listen: false)
        .getList(_user.token, widget.usulanMeetingId)
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final _ortu = Provider.of<OrtuProvider>(context).list;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.className,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationGuru('meeting'),
      body: ChangeNotifierProvider(
        create: (_) => KelasProvider(),
        child: Container(
          margin: EdgeInsets.all(10),
          child: _isLoading
              ? Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator(), SizedBox(height: 10), Text('Please Wait...')],
                  ),
                )
              : _ortu.length > 0
                  ? ListView.builder(
                      itemCount: _ortu.length,
                      itemBuilder: (ctx, i) => UsulanMeetingChosenList(_ortu[i], _user, widget.usulanMeetingId),
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
    );
  }
}
