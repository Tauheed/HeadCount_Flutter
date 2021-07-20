import 'package:flutter/material.dart';
//import 'HomeScreen.dart';
import 'classes/screens/HomeScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return LayoutBuilder(                           //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(                  //return OrientationBuilder
          builder: (context, orientation) {
            //initialize SizerUtil()
            SizerUtil().init(constraints, orientation);  //initialize SizerUtil
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              //theme: ThemeData.light(),
              home: HomeScreen(),
              builder: EasyLoading.init(),
              theme: ThemeData(fontFamily: 'Raleway'),
            );
          },
        );
      },
    );
  }
}

//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
////      theme: ThemeData(
////        primarySwatch: Colors.red,
////        visualDensity: VisualDensity.adaptivePlatformDensity,
////      ),
//      home: HomeScreen(),
//      builder: EasyLoading.init(),
//    );
//  }
//}

