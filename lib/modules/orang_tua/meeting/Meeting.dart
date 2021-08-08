import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/meeting/components/MeetingList.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/meeting/components/UsulanMeetingOrtuList.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/meeting.dart';

class MeetingOrtuPage extends StatefulWidget {
  @override
  _MeetingOrtuPageState createState() => _MeetingOrtuPageState();
}

class _MeetingOrtuPageState extends State<MeetingOrtuPage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _globalKey = new GlobalKey<FormBuilderState>();
  TextEditingController titleController = new TextEditingController();

  User _user;
  bool _isLoading = true;

  @override
  void initState() {
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<MeetingProvider>(context, listen: false)
        .getListOrtuUsulan(token: _user.token, nis: _user.nis)
        .then((_) {
      Provider.of<MeetingProvider>(context, listen: false)
          .getListMeeting(token: _user.token, nis: _user.nis)
          .then((_) => setState(() => _isLoading = false));
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
        bottomNavigationBar: BottomNavigationOrtu('meeting'),
        body: TabBarView(
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
                            itemBuilder: (ctx, i) => UsulanMeetingOrtuList(
                              first: i == 0,
                              last: i == _usulanMeetingData.length,
                              idx: i,
                              user: _user,
                              meeting: _usulanMeetingData[i],
                            ),
                          )
                        : Container(
                            child: Text(
                              'Usulan meeting belum dibuat guru',
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
                              'Tidak ada meeting terdekat',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            width: double.infinity),
              ),
            ),
          ],
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
