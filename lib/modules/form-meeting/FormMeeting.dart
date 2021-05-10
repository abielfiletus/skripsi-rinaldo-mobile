import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/models/user.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';

import 'package:skripsi_rinaldo/utils/BottomNavigation.dart';

class FormMeetingPage extends StatefulWidget {
  @override
  _FormMeetingPageState createState() => _FormMeetingPageState();
}

class _FormMeetingPageState extends State<FormMeetingPage> {
  final GlobalKey<FormBuilderState> _globalKey = new GlobalKey<FormBuilderState>();
  TextEditingController titleController = new TextEditingController();

  User _user;
  DateTime _date;
  DateTime _startDate;
  DateTime _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.text_snippet,
          color: Colors.black,
        ),
        title: Text(
          'Form Meeting',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigation(
        role: _user.roleId,
        active: 'form-meeting',
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: padding.top),
          padding: EdgeInsets.all(10),
          child: FormBuilder(
            key: _globalKey,
            child: renderWidget(),
          ),
        ),
      ),
    );
  }

  Widget renderWidget() {
    if (_user.roleId == 1) {
      return teacherWidget();
    } else {
      return parentWidget();
    }
  }

  Widget teacherWidget() {
    return Column(
      children: [
        FormBuilderTextField(
          name: 'title',
          controller: titleController,
          maxLength: 100,
          textCapitalization: TextCapitalization.words,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context, errorText: 'Harus terisi'),
          ]),
          decoration: InputDecoration(
            labelText: 'Judul Meeting',
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
        ),
        SizedBox(height: 15),
        FormBuilderDateTimePicker(
          name: 'start date',
          alwaysUse24HourFormat: true,
          firstDate: DateTime(1700),
          lastDate: DateTime(DateTime.parse(new DateTime.now().toString()).year, 12),
          format: DateFormat('yyyy-MM-dd HH:mm'),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Tanggal Awal',
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
            [FormBuilderValidators.required(context, errorText: 'Harus terisi')],
          ),
          onChanged: (value) => setState(() => _startDate = value),
        ),
        SizedBox(height: 15),
        FormBuilderDateTimePicker(
          name: 'end date',
          alwaysUse24HourFormat: true,
          firstDate: DateTime(1700),
          lastDate: DateTime(DateTime.parse(new DateTime.now().toString()).year, 12),
          format: DateFormat('yyyy-MM-dd HH:mm'),
          textInputAction: TextInputAction.next,
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
            [FormBuilderValidators.required(context, errorText: 'Harus terisi')],
          ),
          onChanged: (value) => setState(() => _startDate = value),
        ),
        SizedBox(height: 15),
        buttonSubmit(),
      ],
    );
  }

  Widget parentWidget() {
    return Column(
      children: [
        Text(
          'Monthly Parent Meeting',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 15),
        FormBuilderDateTimePicker(
          name: 'date',
          alwaysUse24HourFormat: true,
          firstDate: new DateTime.now(),
          lastDate: new DateTime.now().add(Duration(days: 7)),
          format: DateFormat('yyyy-MM-dd HH:mm'),
          decoration: InputDecoration(
            labelText: 'Tanggal Meeting',
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
            [FormBuilderValidators.required(context, errorText: 'Harus terisi')],
          ),
          onChanged: (value) => setState(() => _date = value),
        ),
        SizedBox(height: 15),
        buttonSubmit(),
      ],
    );
  }

  Widget buttonSubmit() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
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
                        "Submit",
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
              if (validateAndSave()) {
                setState(() => _isLoading = true);
              } else {
                setState(() => _isLoading = false);
              }
            },
          ),
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
