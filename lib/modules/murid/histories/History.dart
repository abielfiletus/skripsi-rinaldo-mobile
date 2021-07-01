import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/providers/history.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/modules/murid/BottomNavigation.dart';
import 'package:skripsi_rinaldo/modules/murid/histories/components/HistoryList.dart';

class HistoryMuridPage extends StatefulWidget {
  @override
  _HistoryMuridPageState createState() => _HistoryMuridPageState();
}

class _HistoryMuridPageState extends State<HistoryMuridPage> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();

  DateTime _startDate = DateTime.parse(new DateTime.now().subtract(Duration(days: 30)).toString());
  DateTime _endDate = DateTime.parse(new DateTime.now().toString());

  bool _isLoading = true;
  User _user;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<HistoryProvider>(context, listen: false)
        .getList(
          token: _user.token,
          userId: _user.id.toString(),
          startDate: DateFormat('yyyy-MM-dd HH:mm').format(_startDate),
          endDate: DateFormat('yyyy-MM-dd HH:mm').format(_endDate),
        )
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _histories = Provider.of<HistoryProvider>(context).list;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.history,
          color: Colors.black,
        ),
        title: Text(
          'History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationMurid('history'
      ),
      body: ChangeNotifierProvider(
        create: (_) => HistoryProvider(),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              FormBuilder(
                child: Expanded(
                  child: Column(
                    children: [
                      FormBuilderDateTimePicker(
                        inputType: InputType.date,
                        name: 'start date',
                        firstDate: DateTime(1700),
                        lastDate: DateTime(_startDate.year, 12),
                        format: DateFormat('yyyy-MM-dd HH:mm'),
                        decoration: InputDecoration(
                          labelText: 'Tanggal Mulai',
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black26,
                              width: 1.0,
                            ),
                          ),
                        ),
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(context, errorText: 'Tanggal Mulai tidak boleh kosong')],
                        ),
                        onChanged: (value) => setState(
                          () => _startDate = value,
                        ),
                        initialValue: _startDate,
                      ),
                      SizedBox(height: 10),
                      FormBuilderDateTimePicker(
                        inputType: InputType.date,
                        name: 'end date',
                        firstDate: DateTime(1700),
                        lastDate: DateTime(_endDate.year, 12),
                        format: DateFormat('yyyy-MM-dd HH:mm'),
                        decoration: InputDecoration(
                          labelText: 'Tanggal Akhir',
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black26,
                              width: 1.0,
                            ),
                          ),
                        ),
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(context, errorText: 'Tanggal Akhir tidak boleh kosong')],
                        ),
                        onChanged: (value) => setState(
                          () => _endDate = value,
                        ),
                        initialValue: _endDate,
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            highlightColor: Colors.black12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 15.0,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? Text(
                                        "Please Wait...",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : Text(
                                        "Filter",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                            onTap: () async {
                              Provider.of<HistoryProvider>(context, listen: false)
                                  .getList(
                                    token: _user.token,
                                    userId: _user.id.toString(),
                                    startDate: DateFormat('yyyy-MM-dd HH:mm').format(_startDate),
                                    endDate: DateFormat('yyyy-MM-dd HH:mm').format(_endDate),
                                  )
                                  .then((_) => setState(() => _isLoading = false));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _isLoading
                  ? Container(
                      height: size.height / 1.7,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator(), SizedBox(height: 10), Text('Please Wait...')],
                      ),
                    )
                  : Container(
                      height: size.height / 1.7,
                      child: ListView.builder(
                        itemCount: _histories.length,
                        itemBuilder: (ctx, i) {
                          return HistoryListMurid(
                            first: i == 0,
                            last: i == _histories.length - 1,
                            durasi: _histories[i].durasi,
                            kelulusan: _histories[i].status,
                            namaMateri: _histories[i].classMateriName,
                            nilai: _histories[i].nilai,
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
