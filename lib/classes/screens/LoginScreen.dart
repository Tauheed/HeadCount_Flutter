import 'package:flutter/material.dart';
import 'package:headcount/classes/custom_views/RoundCornerButton.dart';
import 'package:headcount/classes/screens/AddCustomerScreen.dart';
import 'SignUpScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:headcount/classes/services/NetworkingManager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:headcount/classes/extension/EmailValidation_Extension.dart';
import 'dart:convert';
import 'package:sizer/sizer.dart';
import 'package:headcount/classes/utilities/Utility.dart';


const lightPurpleColor = Color.fromRGBO(110, 74, 151, 1.0);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController pswController = TextEditingController();

  void loginAction() async {
    FocusScope.of(context).unfocus();

    if (!emailController.text.isValidEmail()) {
      EasyLoading.showToast('Email should be in valid format.');
      return;
    }

    if (pswController.text.length < 7) {
      EasyLoading.showToast('Password should be minimum 8 character.');
      return;
    }

    Utility.check().then((intenet) {
      if (intenet != null && intenet) {
        postLoginAPI();// Internet Present Case
      }
      else {
        EasyLoading.showToast('Network connection not available.');// No-Internet Case
      }
    });

    //postLoginAPI();
  }


  void postLoginAPI() async{

    EasyLoading.show(status: 'please wait...', maskType: EasyLoadingMaskType.black);

    // set up POST request arguments
    final String emailStr = emailController.text;
    final String pswStr = pswController.text;

    String url = 'http://3.208.64.209/auth/login/';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"email": "$emailStr", "password": "$pswStr"}';


    NetworkingManager nwManager = NetworkingManager(url: url, headers: headers, json: json);
    var response = await nwManager.postRequest();
    EasyLoading.dismiss();
    bool isSuccess = response[0];
    if (isSuccess) {

      String body = response[1];
      String token = jsonDecode(body)['token'];

      final storage = FlutterSecureStorage();
      await storage.write(key: 'TokenKey', value: token);

      pswController.text = '';
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AddCustomerScreen();
      }));
    }
    else {
      String body = response[1];
      String msg = jsonDecode(body)['detail'];
      EasyLoading.showToast(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.blueGrey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/lightBG.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Container(
              //color: Colors.grey,
              height: MediaQuery.of(context).size.height,
              width: 400,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 1.0.h),
                  Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 14.0,
                      backgroundColor: Colors.transparent,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 11.0.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LOGIN',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.0.h),
                  Container(
                    height: 6.7.h,
                    child: TextField(
                      controller: emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
//                      filled: true,
//                      fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.0.h),
                  Container(
                    height: 6.7.h,
                    child: TextField(
                      controller: pswController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  SizedBox(height: 11.0.h),
                  RoundCornerButton(
                    color: lightPurpleColor,
                    title: 'Login',
                    onTap: () {
                      //loginAction();
                      //Utility.showAlert(context, 'text');
                      Utility.showMyDialog(context);

                    },
                  ),
                  SizedBox(height: 11.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Dont have an account?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      FlatButton(
                          child: Text('SignUp',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12.0.sp,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SignUpScreen();
                            }));
                          })
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



//String enteredText .... TextField( onChanged: (newText) { enteredText = newText; },
