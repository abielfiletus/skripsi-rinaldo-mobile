import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/modules/change-password/ChangePassword.dart';
import 'package:skripsi_rinaldo/modules/login/Login.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/utils/Constants.dart';
import 'package:skripsi_rinaldo/utils/FormBuilderImagePicker.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';
import 'package:skripsi_rinaldo/models/user.dart';

class ProfileBody extends StatefulWidget {
  final User user;

  ProfileBody(this.user);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jenisKelaminController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;
  DateTime parsedDate = DateTime.parse(new DateTime.now().toString());
  DateTime _birthDate;
  JenisKelamin _jenisKelamin;
  String _avatar;
  int _role;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name;
    nisController.text = widget.user.nis.toString();
    emailController.text = widget.user.email;
    _birthDate = widget.user.tanggalLahir;
    _jenisKelamin = widget.user.jenisKelamin;
    _role = widget.user.roleId;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Container(
      margin: EdgeInsets.only(top: padding.top),
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26, spreadRadius: 1)],
                  ),
                  child: Container(
                    width: 150,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: widget.user.avatar.isNotEmpty
                          ? Image.network(
                              widget.user.avatar,
                              fit: BoxFit.fill,
                            )
                          : widget.user.jenisKelamin == JenisKelamin.laki
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
              SizedBox(height: 15),
              FormBuilder(
                key: globalFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormBuilderTextField(
                      name: 'name',
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      controller: nameController,
                      maxLength: 50,
                      decoration: InputDecoration(
                        labelText: 'Nama',
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
                        [FormBuilderValidators.required(context, errorText: 'harus terisi')],
                      ),
                    ),
                    SizedBox(height: 15),
                    FormBuilderRadioGroup(
                      name: 'jenis kelamin',
                      initialValue: widget.user.jenisKelamin,
                      options: [
                        FormBuilderFieldOption(
                          child: Text('Laki-Laki'),
                          value: JenisKelamin.laki,
                        ),
                        FormBuilderFieldOption(
                          child: Text('Perempuan'),
                          value: JenisKelamin.perempuan,
                        )
                      ],
                      decoration: InputDecoration(
                        labelText: 'Jenis Kelamin',
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
                        [FormBuilderValidators.required(context, errorText: 'harus terisi')],
                      ),
                      onChanged: (value) => setState(() => _jenisKelamin = value),
                    ),
                    SizedBox(height: 15),
                    FormBuilderDateTimePicker(
                      name: 'tgl lahir',
                      inputType: InputType.date,
                      firstDate: DateTime(1700),
                      lastDate: DateTime(parsedDate.year, 12),
                      format: DateFormat('yyyy-MM-dd'),
                      initialValue: widget.user.tanggalLahir,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Lahir',
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
                        [FormBuilderValidators.required(context, errorText: 'harus terisi')],
                      ),
                      onChanged: (value) => setState(() => _birthDate = value),
                    ),
                    widget.user.roleId != 2 ? SizedBox() : SizedBox(height: 15),
                    widget.user.roleId != 2
                        ? SizedBox()
                        : FormBuilderTextField(
                            name: 'nis',
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            controller: nisController,
                            maxLength: 20,
                            decoration: InputDecoration(
                              labelText: 'NIS',
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
                              [FormBuilderValidators.required(context, errorText: 'harus terisi')],
                            ),
                          ),
                    SizedBox(height: 15),
                    FormBuilderRadioGroup(
                      name: 'role',
                      initialValue: widget.user.roleId,
                      options: [
                        FormBuilderFieldOption(
                          child: Text('Pengajar'),
                          value: 1,
                        ),
                        FormBuilderFieldOption(
                          child: Text('Murid'),
                          value: 2,
                        ),
                        FormBuilderFieldOption(
                          child: Text('Orang Tua'),
                          value: 3,
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Daftar Sebagai',
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
                        [FormBuilderValidators.required(context, errorText: 'harus terisi')],
                      ),
                      onChanged: (value) => setState(() => _role = value),
                      enabled: false,
                    ),
                    SizedBox(height: 15),
                    FormBuilderImagePicker(
                      attribute: 'avatar',
                      title: 'Avatar',
                      maxHeight: 500,
                      maxWidth: 500,
                      imageHeight: 200,
                      imageWidth: MediaQuery.of(context).size.width - 20,
                      maxImages: 1,
                      imageQuality: 100,
                      decoration: InputDecoration(border: InputBorder.none),
                      onChanged: (val) => setState(() => _avatar = val[0]),
                      validators: [FormBuilderValidators.required(context, errorText: 'harus terisi')],
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      name: 'email',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      maxLength: 50,
                      decoration: InputDecoration(
                        labelText: 'Email',
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
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context, errorText: 'harus terisi'),
                        FormBuilderValidators.email(context, errorText: 'email tidak valid'),
                      ]),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[400],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
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

                              try {
                                await Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                ).updateUser(
                                  name: nameController.text,
                                  birthOfDate: _birthDate,
                                  jenisKelamin: _jenisKelamin,
                                  role: _role,
                                  nis: nisController.text,
                                  avatar: _avatar,
                                  email: emailController.text,
                                );
                                setState(() {
                                  _isLoading = false;
                                  _avatar = null;
                                });
                                Fluttertoast.showToast(msg: 'Berhasil mengubah data profile');
                              } on HttpException catch (err) {
                                setState(() => _isLoading = false);
                                Fluttertoast.showToast(
                                  msg: err.toString(),
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              } catch (err) {
                                setState(() => _isLoading = false);
                                print(err);
                                Fluttertoast.showToast(
                                  msg: 'Gagal melakukan pendaftaran. Silakan coba lagi.',
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              }
                            } else {
                              setState(() => _isLoading = false);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
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
                                      "Change Password",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                          ),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ChangePasswordPage())),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
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
                                      "Logout",
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
                            try {
                              await Provider.of<AuthProvider>(context, listen: false).logout();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => LoginPage()));
                              Fluttertoast.showToast(msg: 'Berhasil Keluar');
                            } on HttpException catch (err) {
                              setState(() => _isLoading = false);
                              Fluttertoast.showToast(
                                msg: err.toString(),
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            } catch (err) {
                              setState(() => _isLoading = false);
                              Fluttertoast.showToast(
                                msg: 'Gagal keluar. Silakan coba lagi.',
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
