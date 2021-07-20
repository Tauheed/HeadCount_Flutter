import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CircleButton extends StatelessWidget {
  CircleButton({this.color, this.icon, this.onTap});

  final Color color;
  final IconData icon;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onTap,
      elevation: 2.0,
      fillColor: color,//Colors.black26,
      child: Icon(
        icon,
        size: 3.0.h,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }
}
