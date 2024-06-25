import 'dart:ui';

import 'package:flutter/material.dart';

TextStyle myStyle(
    {double fontSize = 15.0,
    family = 'FontMain',
    col = Colors.black,
    weight = FontWeight.w600}) {
  return TextStyle(
    fontFamily: family,
    fontSize: fontSize,
    color: col,
    fontWeight: weight,
  );
}
