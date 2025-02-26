import 'package:flutter/material.dart';
import 'package:light_board/utils/text_format.dart';
import 'package:light_board/utils/colors_available.dart' as ca;
import 'dart:convert';

LightBoardModel lightBoardModelFromJson(String str) => LightBoardModel.fromJson(json.decode(str));

String lightBoardModelToJson(LightBoardModel data) => json.encode(data.toJson());

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

  factory LightBoardModel.fromJson(Map<String, dynamic> json) => LightBoardModel(
        text: json["text"],
        speed: json["speed"],
        textFormat: TextFormatExtension.fromString(json["text_format"]),
        textColor: ca.colorsAvailable[json["text_color"]]!,
        backgroundColor: ca.colorsAvailable[json["background_color"]]!,
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "speed": speed,
        "text_format": textFormat.asString,
        "text_color": ca.colorsAvailable.entries.firstWhere((entry) => entry.value == textColor).key,
        "background_color": ca.colorsAvailable.entries.firstWhere((entry) => entry.value == backgroundColor).key,
    };
}