import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/guru/dashboard/components/MateriList.dart';
import 'package:skripsi_rinaldo/modules/orang_tua/dashboard/components/Meetinglist.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/dashboard.dart';
import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;

class DashboardGuruPage extends StatefulWidget {
  @override
  _DashboardGuruPageState createState() => _DashboardGuruPageState();
}

class _DashboardGuruPageState extends State<DashboardGuruPage> {
  User _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<DashboardProvider>(context, listen: false)
        .getDataGuru(token: _user.token, userId: _user.id.toString())
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DashboardProvider>(context).data;
    final padding = MediaQuery.of(context).padding;
    final now = DateTime.now().hour;
    String greeting = 'Morning';

    if (now >= 15) {
      greeting = 'Evening';
    } else if (now > 10) {
      greeting = 'Afternoon';
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationGuru('home'),
      body: _isLoading
          ? Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator(), SizedBox(height: 10), Text('Please Wait...')],
              ),
            )
          : ChangeNotifierProvider(
              create: (ctx) => DashboardProvider(),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: padding.top),
                  padding: EdgeInsets.only(
                    top: padding.top,
                    left: 15,
                    right: 15,
                    bottom: padding.bottom + 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('$greeting,'),
                                  Text(
                                    '${_user.name.toUpperCase()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    '${_user.roleName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26, spreadRadius: 1)],
                                ),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(150),
                                    child: _user.avatar.isNotEmpty
                                        ? Image.network(
                                            _user.avatar,
                                            fit: BoxFit.fill,
                                          )
                                        : _user.jenisKelamin == constant.JenisKelamin.laki
                                            ? Image.asset(
                                                'assets/images/man.png',
                                                width: 70,
                                                height: 70,
                                              )
                                            : Image.asset(
                                                'assets/images/woman.png',
                                                width: 70,
                                                height: 70,
                                              ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.pending_actions),
                              SizedBox(width: 10),
                              Text(
                                'Meeting Kamu',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                softWrap: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          data != null && data.meeting != null && data.meeting.length > 0
                              ? Column(children: [for (var item in data.meeting) MeetingList(item)])
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0.0, 1.0),
                                        spreadRadius: 0.3,
                                        blurRadius: 3.0,
                                      )
                                    ],
                                  ),
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/images/empty_pending_task.jpg', width: 150, height: 150),
                                      Text('Tidak ada meeting terdekat', style: TextStyle(fontStyle: FontStyle.italic)),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 45),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.book_outlined),
                              SizedBox(width: 10),
                              Text(
                                'Materi Sedang Berlangsung',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                softWrap: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          data != null && data.materi != null && data.materi.length > 0
                              ? Column(children: [for (var item in data.materi) MateriList(item)])
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0.0, 1.0),
                                        spreadRadius: 0.3,
                                        blurRadius: 3.0,
                                      )
                                    ],
                                  ),
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/images/empty_class.jpg', width: 190, height: 190),
                                      Text('Belum ada materi yang berlangsung',
                                          style: TextStyle(fontStyle: FontStyle.italic)),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
