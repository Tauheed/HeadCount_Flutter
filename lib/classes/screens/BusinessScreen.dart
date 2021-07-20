import 'package:flutter/material.dart';
import 'package:headcount/classes/cells/BarCell.dart';
import 'package:headcount/classes/models/BusinessModel.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:headcount/classes/services/NetworkingManager.dart';
import 'dart:convert';
import 'package:headcount/classes/utilities/Utility.dart';

const lightPurpleColor = Color.fromRGBO(110, 74, 151, 1.0);

Timer timer;
List<BusinessModel> barListArry = [];


class BusinessScreen extends StatefulWidget {
  @override
  _BusinessScreenState createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {

  static DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('hh:mm a');
  String formattedDate = formatter.format(now);

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(minutes: 1), (_) {
      setState(() {
        now = DateTime.now();
        formattedDate = formatter.format(now);
      });
    });


    Utility.check().then((intenet) {
      if (intenet != null && intenet) {
        businessListAPI();
      }
      else {
        EasyLoading.showToast('Network connection not available.');// No-Internet Case
      }
    });

    //businessListAPI();
  }


  void businessListAPI() async {

    EasyLoading.show(status: 'please wait...', maskType: EasyLoadingMaskType.black);
    final String url = 'http://3.208.64.209/business/';

    Map<String, String> headers = {};
    NetworkingManager nwManager = NetworkingManager(url: url, headers: headers, json: '');
    var response = await nwManager.getRequest();
    EasyLoading.dismiss();
    bool isSuccess = response[0];
    if (isSuccess) {
      setState(() {
        var barList = json.decode(response[1]) as List;
        barListArry = barList.map<BusinessModel>((json) => BusinessModel.fromJson(json)).toList();
      });
    }
    else {
      String body = response[1];
      String msg = jsonDecode(body)['detail'];
      EasyLoading.showToast(msg);
    }
  }


  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
//              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: 400,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 14.0,
                      backgroundColor: Colors.transparent,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close, color: Colors.black)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'CAPACITY MONITOR',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formattedDate,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: barListArry.length,
                        itemBuilder: (context, index) {
                          return BarCell(
                            barList: barListArry[index],
                            selectedCell: () {},
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
