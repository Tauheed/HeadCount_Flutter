import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utility {


  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  // ignore: missing_return
  static bool isInternetAvaial() {
    Utility.check().then((intenet) {
      if (intenet != null && intenet) {
        print('yesssss');
        return true;// Internet Present Case
      }
      else {
        print('nooooooo');
        return false;// No-Internet Case
      }
    });
  }


  static void showAlert(BuildContext context, String text) {
    var alert = new AlertDialog(
      content: Container(
        child: Row(
          children: <Widget>[Text(text)],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }



  static Future<void> showMyDialog(BuildContext context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button! if false.
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
              title: Text('ALert'),
              content: Text('asdasjdh ajdhaj sdgajs d,agjsd jasdgas,d ashdmgajsgdj adsd asdas d'),
              actions: [
                CupertinoDialogAction(child: Text('NO'), onPressed: (){Navigator.pop(context);}),
                CupertinoDialogAction(child: Text('YES'), onPressed: (){
                },),
              ],
            );
      },
    );
  }
}