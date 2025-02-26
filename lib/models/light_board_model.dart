import 'package:flutter/material.dart';
import 'package:light_board/utils/text_format.dart';

class LightBoardModel {
  String text;
  int speed;
  TextFormat textFormat;
  Color textColor;
  Color backgroundColor;

  LightBoardModel({
    required this.text,
    this.speed = 50,
    this.textFormat = TextFormat.LIGHT,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
  });
}