import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';
import 'package:skripsi_rinaldo/utils/Constants.dart';

class FormRegister extends StatefulWidget {
  @override
  _ForHRegisterState createState() => _ForHRegisterState();
}

class _ForHRegisterState extends State<FormRegister> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jenisKelaminController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController = TextEditingController();

  bool _isLoading = false;
  bool _passVisible = false;
  bool _confirmPassVisible = false;
  DateTime parsedDate = DateTime.parse(new DateTime.now().toString());
  DateTime _birthDate;
  JenisKelamin _jenisKelamin;
  int _role;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Container(
      margin: EdgeInsets.only(
        bottom: padding.bottom + 10,
        top: padding.top + 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: FormBuilder(
          key: globalFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                attribute: 'name',
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
                validators: [FormBuilderValidators.required(errorText: 'harus terisi')],
              ),
              SizedBox(height: 15),
              FormBuilderRadioGroup(
                attribute: 'jenis kelamin',
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
                validators: [FormBuilderValidators.required(errorText: 'harus terisi')],
                onChanged: (value) => setState(() => _jenisKelamin = value),
              ),
              SizedBox(height: 15),
              FormBuilderDateTimePicker(
                attribute: 'tgl lahir',
                inputType: InputType.date,
                firstDate: DateTime(1700),
                lastDate: DateTime(parsedDate.year, 12),
                format: DateFormat('yyyy-MM-dd'),
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
                validators: [FormBuilderValidators.required(errorText: 'harus terisi')],
                onChanged: (value) => setState(() => _birthDate = value),
              ),
              SizedBox(height: 15),
              FormBuilderTextField(
                attribute: 'nis',
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
                validators: [FormBuilderValidators.required(errorText: 'harus terisi')],
              ),
              SizedBox(height: 15),
              FormBuilderRadioGroup(
                attribute: 'role',
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
                validators: [FormBuilderValidators.required(errorText: 'harus terisi')],
                onChanged: (value) => setState(() => _role = value),
              ),
              SizedBox(height: 15),
              FormBuilderTextField(
                attribute: 'email',
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
                validators: [
                  FormBuilderValidators.required(errorText: 'harus terisi'),
                  FormBuilderValidators.email(errorText: 'email tidak valid'),
                ],
              ),
              SizedBox(height: 15),
              FormBuilderTextField(
                attribute: 'password',
                textInputAction: TextInputAction.next,
                controller: passwordController,
                obscureText: !_passVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: !_passVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() => _passVisible = !_passVisible);
                    },
                  ),
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
                validators: [
                  FormBuilderValidators.required(errorText: 'harus terisi'),
                  FormBuilderValidators.minLength(6, errorText: 'minimal 6 karakter'),
                  (value) {
                    Pattern patternSmallChar = r'([a-z])';
                    Pattern patternCapitalChar = r'([A-Z])';
                    Pattern patternNumber = r'([0-9])';

                    if (value.isEmpty) return "Password tidak boleh kosong";
                    if (value.length < 6) return "Password harus memiliki 6 karakter minimal";
                    if (!new RegExp(patternSmallChar).hasMatch(value)) return "Password harus memiliki 1 huruf kecil";
                    if (!new RegExp(patternCapitalChar).hasMatch(value)) return "Password harus memiliki 1 huruf besar";
                    if (!new RegExp(patternNumber).hasMatch(value)) return "Password harus memiliki 1 angka";
                    return null;
                  }
                ],
              ),
              SizedBox(height: 15),
              FormBuilderTextField(
                attribute: 'password confirmation',
                textInputAction: TextInputAction.done,
                controller: passwordConfirmationController,
                obscureText: !_confirmPassVisible,
                decoration: InputDecoration(
                  labelText: 'Password Confirmation',
                  suffixIcon: IconButton(
                    icon: !_confirmPassVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() => _confirmPassVisible = !_confirmPassVisible);
                    },
                  ),
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
                validators: [
                  FormBuilderValidators.required(errorText: 'harus terisi'),
                  (val) {
                    if (val != passwordController.text) return 'tidak sama dengan password';
                    return null;
                  },
                ],
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
                          ).register(
                            nameController.text,
                            _birthDate,
                            _jenisKelamin,
                            _role,
                            nisController.text,
                            emailController.text,
                            passwordController.text,
                            passwordConfirmationController.text,
                          );
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(msg: 'Berhasil daftar. Silakan Login');
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
