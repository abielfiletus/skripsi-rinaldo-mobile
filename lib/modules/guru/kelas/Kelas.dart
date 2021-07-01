import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/guru/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/guru/kelas/components/AddClass.dart';
import 'package:skripsi_rinaldo/modules/guru/kelas/components/KelasList.dart';

class KelasGuruPage extends StatefulWidget {
  @override
  _KelasGuruPageState createState() => _KelasGuruPageState();
}

class _KelasGuruPageState extends State<KelasGuruPage> {
  User _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<KelasProvider>(context, listen: false).guruGetClass(token: _user.token, userId: _user.id).then((_) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _kelas = Provider.of<KelasProvider>(context).list;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.book,
          color: Colors.black,
        ),
        title: Text(
          'Kelas',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationGuru('kelas'),
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
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Please Wait...'),
                    ],
                  ),
                )
              : _kelas.length > 0
                  ? ListView.builder(
                      itemCount: _kelas.length,
                      itemBuilder: (ctx, i) {
                        return KelasGuruList(
                          first: i == 0,
                          last: i == _kelas.length - 1,
                          kelas: _kelas[i],
                          user: _user,
                          idx: i,
                        );
                      },
                    )
                  : Container(
                      child: Text(
                        'Anda belum pernah membuat kelas',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      width: double.infinity),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (ctx, _, __) => AddGuruClassDialog(user: _user),
          ),
        ),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
