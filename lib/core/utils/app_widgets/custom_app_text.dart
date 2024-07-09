import 'package:flutter/material.dart';

Widget customTextApp({
  required String text,
  Color color = Colors.black,
  //String fontFamily = 'Poppins',
  double size = 16.0,
  int? maxLine = 1,
  FontWeight fontWeight = FontWeight.normal,
  TextAlign? align,
  overflow = TextOverflow.ellipsis,
}) =>
    Text(
      text,
      maxLines: maxLine,
      overflow: TextOverflow.clip,
      textAlign: align,
      style: TextStyle(
        color: color,
        //fontFamily: fontFamily,
        fontSize: size,
        fontWeight: fontWeight,
        overflow: overflow,
      ),
    );
