import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CardMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .85,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: <Widget>[
          
        ],
      ),
    );
  }
}
