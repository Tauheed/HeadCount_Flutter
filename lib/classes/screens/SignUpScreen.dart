import 'package:flutter/material.dart';
import 'package:headcount/classes/custom_views/RoundCornerButton.dart';
import 'HomeScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:headcount/classes/services/NetworkingManager.dart';
import 'package:headcount/classes/extension/EmailValidation_Extension.dart';
import 'dart:convert';
import 'package:sizer/sizer.dart';
import 'package:headcount/classes/utilities/Utility.dart';

const lightPurpleColor = Color.fromRGBO(110, 74, 151, 1.0);

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pswController = TextEditingController();
  TextEditingController rePswController = TextEditingController();

  void signUpAction() async {
    FocusScope.of(context).unfocus();

    if (nameController.text.length == 0) {
      EasyLoading.showToast('Name should be not blank.');
      return;
    }

    if (!emailController.text.isValidEmail()) {
      EasyLoading.showToast('Email should be in valid format.');
      return;
    }

    if (pswController.text.length < 7) {
      EasyLoading.showToast('Password should be minimum 8 character.');
      return;
    }

    if (pswController.text != rePswController.text) {
      EasyLoading.showToast('Re-enter password should match with the password.');
      return;
    }

    Utility.check().then((intenet) {
      if (intenet != null && intenet) {
        postSignUpAPI();// Internet Present Case
      }
      else {
        EasyLoading.showToast('Network connection not available.');// No-Internet Case
      }
    });
    //postSignUpAPI();
  }

  //Future postLoginAPIReq() async {
  void postSignUpAPI() async{

    EasyLoading.show(status: 'please wait...', maskType: EasyLoadingMaskType.black);

    // set up POST request arguments
    final String emailStr = emailController.text;
    final String pswStr = pswController.text;
    final String nameStr = nameController.text;

    String url = 'http://3.208.64.209/auth/signup/';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"name": "$nameStr", "email": "$emailStr", "password": "$pswStr"}';


    NetworkingManager nwManager = NetworkingManager(url: url, headers: headers, json: json);
    var response = await nwManager.postRequest();
    EasyLoading.dismiss();
    bool isSuccess = response[0];
    if (isSuccess) {
      EasyLoading.showToast('Successfully register, please login');
      Navigator.pop(context);
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
            image: AssetImage("images/signUpBG.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Container(
//              color: Colors.grey,
              height: MediaQuery.of(context).size.height,
              width: 400,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 8.0.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SIGNUP',
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
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  SizedBox(height: 2.0.h),
                  Container(
                    height: 6.7.h,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
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
                  SizedBox(height: 2.0.h),
                  Container(
                    height: 6.7.h,
                    child: TextField(
                      controller: rePswController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                    ),
                  ),
                  SizedBox(height: 11.0.h),
                  RoundCornerButton(
                    color: lightPinkColor,
                    title: 'Signup',
                    onTap: () {
                      signUpAction();
                    },
                  ),
                  SizedBox(height: 11.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'You have an account?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      FlatButton(
                          child: Text('Login',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12.0.sp,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            Navigator.pop(context);
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


