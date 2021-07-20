import 'package:flutter/material.dart';
import 'package:headcount/classes/models/BusinessModel.dart';

// ignore: must_be_immutable
class BarCell extends StatelessWidget {
  BarCell({this.selectedCell, this.barList});

  BusinessModel barList;
  //String menuItem;
  //String menuIcon;
  Function selectedCell;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: selectedCell,
        child: Card(
          margin: EdgeInsets.only(bottom: 0),
          child: Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 20),
                        Text(
                          barList.name.toUpperCase(),
                          maxLines: 3,
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(height: 20),
                        Text(
                            '${barList.currHeadCount}/${barList.totalCapacity}',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(height: 30),
                        Text(
                            (barList.percentCapacity > 50)
                                ? '${barList.percentCapacity}% Capacity ↑'
                                : '${barList.percentCapacity}% Capacity ↓',
                            style: TextStyle(
                                color: (barList.percentCapacity > 50)
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 60),
//                Image.asset(
//                  menuIcon,
//                  width: 150,
//                  height: 150,
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
