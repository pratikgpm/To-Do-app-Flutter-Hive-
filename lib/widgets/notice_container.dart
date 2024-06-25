import 'package:do_it/util/customStyle.dart';
import 'package:flutter/material.dart';

Widget noticeContainer(IconData iconData, String count, String Message) {
  return Container(
    width: 150,
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: Colors.greenAccent, borderRadius: BorderRadius.circular(30)),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Icon(
            iconData,
          ),
          Text(" $count ", style: myStyle()),
          Text(Message,
              style: myStyle(
                fontSize: 10.0,
              )),
        ],
      ),
    ),
  );
}
