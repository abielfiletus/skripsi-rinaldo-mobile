import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/dashboard.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/utils/BottomNavigation.dart';
import 'package:skripsi_rinaldo/utils/Constants.dart' as constant;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<KelasProvider>(context, listen: false).getList(token: _user.token, userId: _user.id).then((_) {
      final data = Provider.of<KelasProvider>(context, listen: false).list;

      if (data.length > 0) {
        Provider.of<DashboardProvider>(context, listen: false)
            .getData(token: _user.token, userId: _user.id.toString(), classId: data[0].id.toString())
            .then((_) => setState(() => _isLoading = false));
      } else {
        setState(() => _isLoading = false);
      }
    });
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
      bottomNavigationBar: BottomNavigation(
        role: _user.roleId,
        active: 'home',
      ),
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
                                'Pendingan Kamu',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                softWrap: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
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
                                Text('Hore tidak ada pendingan', style: TextStyle(fontStyle: FontStyle.italic)),
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
                              Icon(Icons.table_chart),
                              SizedBox(width: 10),
                              Text(
                                'Summary Kamu',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                softWrap: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
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
                            child: data.summary.id != ''
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Table(
                                        columnWidths: {
                                          0: FlexColumnWidth(10),
                                          1: FlexColumnWidth(1),
                                          2: FlexColumnWidth(11),
                                        },
                                        children: [
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: Text('Total Durasi Belajar'),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: Text(':'),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: Text(data.summary.durasi != '' ? data.summary.durasi + ' jam' : '-'),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: Text('Rata - Rata Nilai'),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: Text(':'),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: Text(data.summary.nilai),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: Text('Status Kelulusan'),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: Text(':'),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                    child: Text(data.summary.status)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/images/empty_class.jpg', width: 190, height: 190),
                                      Text('Kamu belum terdaftar di kelas', style: TextStyle(fontStyle: FontStyle.italic)),
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
                              Icon(Icons.campaign),
                              SizedBox(width: 10),
                              Text(
                                'Pengumuman',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                softWrap: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
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
                                Image.asset('assets/images/empty_news.jpg', width: 190, height: 190),
                                Text('Tidak ada pengumuman', style: TextStyle(fontStyle: FontStyle.italic)),
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
