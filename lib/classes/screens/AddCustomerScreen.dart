import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:headcount/classes/custom_views/CircleButton.dart';
import 'package:headcount/classes/custom_views/RoundCornerButton.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:headcount/classes/services/NetworkingManager.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:headcount/classes/utilities/Utility.dart';

const lightPurpleColor = Color.fromRGBO(110, 74, 151, 1.0);
const bgColor = Color.fromRGBO(75, 46, 73, 0.6);

class AddCustomerScreen extends StatefulWidget {
  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  void initState() {
    super.initState();

    saveAction();
  }

  int capacityCounter = 0;

  String name = '';
  int totalCapacity = 0;
  int currentHeadcount = 0;
  double percentCapacity = 0;

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("5min", style: TextStyle(color: Colors.white)),
    1: Text("15min", style: TextStyle(color: Colors.white)),
    2: Text("30min", style: TextStyle(color: Colors.white)),
    3: Text("45+min", style: TextStyle(color: Colors.white))
  };

  void saveAction() async {
    EasyLoading.show(
        status: 'please wait...', maskType: EasyLoadingMaskType.black);

    int eventType = (capacityCounter > 0) ? 1 : -1;
    int headCount =
        (capacityCounter > 0) ? capacityCounter : capacityCounter.abs();

    int waitTime = 5;
    switch (segmentedControlGroupValue) {
      case 0:
        waitTime = 5;
        break;
      case 1:
        waitTime = 15;
        break;
      case 2:
        waitTime = 30;
        break;
      case 3:
        waitTime = 45;
        break;
    }

    Utility.check().then((intenet) {
      if (intenet != null && intenet) {
        patchBusinessAPI(headCount: headCount, eventType: eventType, waitTime: waitTime);// Internet Present Case
      }
      else {
        EasyLoading.showToast('Network connection not available.');// No-Internet Case
      }
    });

    //patchBusinessAPI(headCount: headCount, eventType: eventType, waitTime: waitTime);
  }

  void patchBusinessAPI({headCount: int, eventType: int, waitTime: int}) async {
    final storage = FlutterSecureStorage();
    String tokenValue = await storage.read(key: 'TokenKey');
    print('storage$tokenValue');

    String url = 'http://3.208.64.209/business/capacity/';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Token $tokenValue"
    };
    String json =
        '{"quantity": "$headCount", "event_type": "$eventType", "wait_time": "$waitTime"}';
    print('json$json');

    NetworkingManager nwManager =
        NetworkingManager(url: url, headers: headers, json: json);
    var response = await nwManager.patchRequest();
    EasyLoading.dismiss();
    bool isSuccess = response[0];
    if (isSuccess) {
      String body = response[1];

      setState(() {
        print(jsonDecode(body));
        name = jsonDecode(body)['name'];
        totalCapacity = jsonDecode(body)['total_capacity'];
        currentHeadcount = jsonDecode(body)['current_headcount'];
        percentCapacity = jsonDecode(body)['percent_capacity'];
        capacityCounter = 0;
      });
    } else {
      String body = response[1];
      //String msg = jsonDecode(body)['detail'];
      EasyLoading.showToast('Something went wrong, try again!');
    }
  }

  void logoutAction() async {

    Utility.check().then((intenet) {
      if (intenet != null && intenet) {
      }
      else {
        EasyLoading.showToast('Network connection not available.');// No-Internet Case
        return;
      }
    });


    EasyLoading.show(status: 'please wait...', maskType: EasyLoadingMaskType.black);

    String url = 'http://3.208.64.209/auth/logout/';

    final storage = FlutterSecureStorage();
    String tokenValue = await storage.read(key: 'TokenKey');

    Map<String, String> headers = {"Authorization": "Token $tokenValue"};

    NetworkingManager nwManager = NetworkingManager(url: url, headers: headers, json: '');
    var response = await nwManager.deleteRequest();
    EasyLoading.dismiss();

    await storage.write(key: 'TokenKey', value: '');
    Navigator.pop(context);

//    bool isSuccess = response[0];
//
//    if (isSuccess) {
//      final storage = FlutterSecureStorage();
//      await storage.write(key: 'TokenKey', value: '');
//      Navigator.pop(context);
//    }
//    else {
//      String body = response[1];
//      String msg = jsonDecode(body)['detail'];
//      EasyLoading.showToast(msg);
//    }
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Container(
//              color: Colors.grey,
              height: MediaQuery.of(context).size.height,
              width: 400,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 1.0.h),
                  Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 1.5.h,
                      backgroundColor: Colors.transparent,
                      child: GestureDetector(
                          onTap: () {
                            logoutAction();
                          },
                          child: Icon(Icons.close, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 1.0.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LOGGED IN AS',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 7.0.h),
                  Text(
                    'ADD CUSTOMER',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Row contents horizontally,
                    children: <Widget>[
                      CircleButton(
                          color: Colors.black26,
                          icon: Icons.remove,
                          onTap: () {
                            setState(() {
                              capacityCounter--;
                            });
                          }),
                      SizedBox(width: 20),
                      Text(
                        capacityCounter.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0.sp,
                            color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      CircleButton(
                          color: lightPurpleColor,
                          icon: Icons.add,
                          onTap: () {
                            setState(() {
                              capacityCounter++;
                            });
                          }),
                    ],
                  ),
                  SizedBox(height: 11.0.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Wait time',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.0.h),
                  Container(
                    child: CupertinoSlidingSegmentedControl(
                        groupValue: segmentedControlGroupValue,
                        backgroundColor: Colors.black26,
                        thumbColor: lightPurpleColor,
                        children: myTabs,
                        onValueChanged: (i) {
                          setState(() {
                            segmentedControlGroupValue = i;
                          });
                        }),
                  ),
                  SizedBox(height: 9.0.h),
                  Text(
                    'Current # = $currentHeadcount',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Capacity # = $totalCapacity',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 11.0.h),
                  RoundCornerButton(
                    color: lightPurpleColor,
                    title: 'SAVE',
                    onTap: () {
                      saveAction();
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
