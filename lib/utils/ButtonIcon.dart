import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {
  final Icon icon;
  final String text;
  final FontWeight fontWeight;
  final BorderSide borderSideTop;
  final Function onPress;

  ButtonIcon({
    @required this.icon,
    @required this.text,
    @required this.fontWeight,
    @required this.borderSideTop,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: borderSideTop),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.black12,
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  icon,
                  Text(
                    text,
                    style: TextStyle(fontWeight: fontWeight),
                  ),
                ],
              ),
            ),
          ),
          onTap: onPress ?? () async {},
        ),
      ),
    );
  }
}
