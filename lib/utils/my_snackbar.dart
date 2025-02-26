import 'package:flutter/material.dart';

class MySnackbar {
  static void show(
      {required BuildContext context,
      required String text,
      Duration duration = const Duration(seconds: 3)}) {

    FocusScope.of(context).requestFocus(FocusNode());

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: Colors.black,
      duration: duration,
    ));
  }
}
