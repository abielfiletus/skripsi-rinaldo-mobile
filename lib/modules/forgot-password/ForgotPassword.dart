import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/utils/HttpException.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormBuilderState> globalFormKey =
      new GlobalKey<FormBuilderState>();
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Form Forgot Password',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Container(
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
                    FormBuilderValidators.required(context,
                        errorText: 'harus terisi'),
                    FormBuilderValidators.email(context,
                        errorText: 'email tidak valid'),
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
                            ).forgotPassword(emailController.text);
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                                msg:
                                    'Berhasil Reset Password. Silahkan login dengan tanggal lahir yang terdaftar.');
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
                              msg:
                                  'Gagal melakukan reset password. Silakan coba lagi.',
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
