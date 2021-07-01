import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/providers/auth.dart';
import 'package:skripsi_rinaldo/modules/murid/quiz/components/QuizList.dart';

class QuizMuridPage extends StatefulWidget {
  final int classQuizId;
  final int classId;
  final int userId;
  final int classMateriId;

  QuizMuridPage({
    @required this.classQuizId,
    @required this.classId,
    @required this.classMateriId,
    @required this.userId,
  });

  @override
  _QuizMuridPageState createState() => _QuizMuridPageState();
}

class _QuizMuridPageState extends State<QuizMuridPage> {
  String _token;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _token = Provider.of<AuthProvider>(context, listen: false).user.token;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: padding.top,
          left: 15,
          right: 15,
        ),
        padding: EdgeInsets.only(top: 20),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : QuizListMurid(
                token: _token,
                classQuizId: widget.classQuizId,
                classId: widget.classId,
                classMateriId: widget.classMateriId,
                userId: widget.userId,
              ),
      ),
    );
  }
}
