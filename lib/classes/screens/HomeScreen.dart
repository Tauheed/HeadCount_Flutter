import 'package:flutter/material.dart';
import 'package:headcount/classes/custom_views/RoundCornerButton.dart';
import 'package:headcount/classes/screens/AddCustomerScreen.dart';
import 'package:headcount/classes/screens/BusinessScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'LoginScreen.dart';
import 'BusinessScreen.dart';
import 'package:sizer/sizer.dart';

const lightPurpleColor = Color.fromRGBO(110, 74, 151, 1.0);
const lightPinkColor = Color.fromRGBO(188, 112, 149, 1.0);

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bgImage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: Container(
//              color: Colors.grey,
              height: MediaQuery.of(context).size.height,
              width: 400,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 11.0.h),
                  SizedBox(
                    width: 180,
                    child: Text(
                      'Welcome to Capacity Monitor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.3.h),
                  SizedBox(
                    width: 350,
                    child: Text(
                      'The best way to plan your nightlife activities and monitor how busy a bar/club is. Lets get started!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12.0.sp,),
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  Text('CONTINUE WITH:', style: TextStyle(color: Colors.white,)),
                  SizedBox(height: 1.0.h),
                  RoundCornerButton(color: lightPurpleColor, title: 'BAR', onTap: () {
                    navigateToLoginORCustomer(context);
                  }),

                  SizedBox(height: 1.0.h),
                  RoundCornerButton(color: lightPinkColor, title: 'CUSTOMER',
                    onTap: () {
                      navigateToBusinessScreen(context);
                    },
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

void navigateToLoginORCustomer(BuildContext context) async{
  final storage = FlutterSecureStorage();
  String tokenValue = await storage.read(key: 'TokenKey');
  print('tokenValue$tokenValue');
  Navigator.push(context,
      MaterialPageRoute(builder: (context) {
        return (tokenValue?.length == 0 || tokenValue == null) ? LoginScreen():AddCustomerScreen();
      }));
}


void navigateToBusinessScreen(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) {
        return BusinessScreen();
      }));
}