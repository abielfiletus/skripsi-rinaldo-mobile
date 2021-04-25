import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class FormChangePassword extends StatefulWidget {
  @override
  _FormChangePasswordState createState() => _FormChangePasswordState();
}

class _FormChangePasswordState extends State<FormChangePassword> {
  final GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController = TextEditingController();

  bool _isLoading = false;
  bool _passVisible = false;
  bool _confirmPassVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      child: Form(
        key: globalFormKey,
        child: Column(
          children: [
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
                        ).updatePassword(passwordController.text);
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                          msg: 'Berhasil mengubah password.',
                        );
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
                          msg: 'Gagal mengubah password. Silakan coba lagi.',
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
