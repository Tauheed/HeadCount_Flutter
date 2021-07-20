import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundCornerButton extends StatelessWidget {
  RoundCornerButton({this.color, this.title, this.onTap});

  final Color color;
  final String title;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 6.0.h,
      child: RaisedButton(
        //padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        color: color,
        shape: StadiumBorder(),
        onPressed: onTap,
        child: Text(title,
            style: TextStyle(fontSize: 13.0.sp, color: Colors.white)),
      ),
    );
  }
}
