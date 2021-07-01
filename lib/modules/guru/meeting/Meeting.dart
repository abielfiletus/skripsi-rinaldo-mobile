import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/guru/meeting/components/AddMeeting.dart';
import 'package:skripsi_rinaldo/modules/guru/meeting/components/AddUsulanMeeting.dart';
import 'package:skripsi_rinaldo/modules/guru/meeting/components/MeetingList.dart';
import 'package:skripsi_rinaldo/modules/guru/meeting/components/UsulanMeetingList.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/meeting.dart';

class MeetingGuruPage extends StatefulWidget {
  @override
  _MeetingGuruPageState createState() => _MeetingGuruPageState();
}

class _MeetingGuruPageState extends State<MeetingGuruPage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _globalKey = new GlobalKey<FormBuilderState>();
  TextEditingController titleController = new TextEditingController();

  TabController _controller;
  int _selectedIndex;
  User _user;
  bool _isLoading = true;

  @override
  void initState() {
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<MeetingProvider>(context, listen: false).getList(token: _user.token, userId: _user.id.toString()).then((_) {
      Provider.of<MeetingProvider>(context, listen: false)
          .getListMeeting(token: _user.token, userId: _user.id.toString())
          .then((_) => setState(() => _isLoading = false));
    });

    _controller = TabController(length: 2, vsync: this);

    _controller.addListener(() {
      setState(() => _selectedIndex = _controller.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _usulanMeetingData = Provider.of<MeetingProvider>(context).list;
    final _meetingData = Provider.of<MeetingProvider>(context).listMeeting;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.text_snippet,
            color: Colors.black,
          ),
          title: Text(
            'Meeting',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            child: TabBar(
              controller: _controller,
              unselectedLabelColor: Colors.black.withOpacity(0.3),
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  child: Text('Usulan Meeting'),
                ),
                Tab(
                  child: Text('Jadwal Meeting'),
                ),
              ],
            ),
            preferredSize: Size.fromHeight(30.0),
          ),
        ),
        bottomNavigationBar: BottomNavigationGuru('meeting'),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[
            ChangeNotifierProvider(
              create: (_) => MeetingProvider(),
              child: Container(
                margin: EdgeInsets.all(10),
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
                    : _usulanMeetingData.length > 0
                        ? ListView.builder(
                            itemCount: _usulanMeetingData.length,
                            itemBuilder: (ctx, i) => UsulanMeetingGuruList(
                              first: i == 0,
                              last: i == _usulanMeetingData.length,
                              idx: i,
                              user: _user,
                              meeting: _usulanMeetingData[i],
                            ),
                          )
                        : Container(
                            child: Text(
                              'Anda belum pernah membuat usulan meeting',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            width: double.infinity),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => MeetingProvider(),
              child: Container(
                margin: EdgeInsets.all(10),
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
                    : _meetingData.length > 0
                        ? ListView.builder(
                            itemCount: _meetingData.length,
                            itemBuilder: (ctx, i) => MeetingGuruList(
                              first: i == 0,
                              last: i == _meetingData.length,
                              idx: i,
                              user: _user,
                              meeting: _meetingData[i],
                            ),
                          )
                        : Container(
                            child: Text(
                              'Anda belum pernah membuat meeting',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            width: double.infinity),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_selectedIndex == 0) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (ctx, _, __) => AddGuruUsulanMeetingDialog(user: _user),
                ),
              );
            } else {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (ctx, _, __) => AddGuruMeetingDialog(user: _user),
                ),
              );
            }
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
