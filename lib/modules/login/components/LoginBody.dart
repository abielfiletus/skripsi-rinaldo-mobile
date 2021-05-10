import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';
import 'package:skripsi_rinaldo/modules/forgot-password/ForgotPassword.dart';
import 'package:skripsi_rinaldo/modules/register/Register.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  GlobalKey<FormBuilderState> globalFormKey = new GlobalKey<FormBuilderState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _passVisible = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FormBuilder(
        key: globalFormKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'email',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email),
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
            SizedBox(height: 15),
            FormBuilderTextField(
              name: 'password',
              textInputAction: TextInputAction.done,
              controller: passwordController,
              obscureText: _passVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: _passVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
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
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context, errorText: 'harus terisi'),
                FormBuilderValidators.minLength(context, 6, errorText: 'minimal 6 karakter'),
              ]),
            ),
            SizedBox(height: 15),
            RichText(
              text: TextSpan(
                text: 'Lupa Password ?',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ForgotPasswordPage(),
                      ),
                    );
                  },
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
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
                                  "Login",
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
                        if (!_isLoading) {
                          setState(() => _isLoading = true);

                          if (validateAndSave()) {
                            try {
                              await Provider.of<AuthProvider>(context, listen: false).login(
                                emailController.text,
                                passwordController.text,
                              );
                              Fluttertoast.showToast(msg: 'Successfully Login.');
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
                                msg: err.toString(),
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          } else {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.amber[300],
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
                          child: Text(
                            "Sign Up",
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
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => RegisterPage()));
                      },
                    ),
                  ),
                ),
              ],
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
