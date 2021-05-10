import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skripsi_rinaldo/modules/quiz/components/QuizList.dart';
import 'package:skripsi_rinaldo/providers/auth.dart';

class QuizPage extends StatefulWidget {
  final int classQuizId;
  final int classId;
  final int userId;
  final int classMateriId;

  QuizPage({
    @required this.classQuizId,
    @required this.classId,
    @required this.classMateriId,
    @required this.userId,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
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
            : QuizList(
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
