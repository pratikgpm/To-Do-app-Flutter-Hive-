import 'package:flutter/material.dart';

Widget DateTimeField(bool isDate, ElevatedButton button, DateTime dateTime) {
  return Container(
    padding: EdgeInsets.only(left: 15, right: 5),
    width: 220,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        Text(
          isDate
              ? '${dateTime.day} : ${dateTime.month} : ${dateTime.year}'
              : '${dateTime.hour} : ${dateTime.minute}',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        button,
      ],
    ),
  );
}
