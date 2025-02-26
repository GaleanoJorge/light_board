import 'package:flutter/material.dart';
import 'package:light_board/src/config_screen.dart';
import 'package:light_board/src/light_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LightBoard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: ConfigScreen.routeName,
      routes: {
        ConfigScreen.routeName: (BuildContext context) => const ConfigScreen(),
        LightBoard.routeName: (BuildContext context) => const LightBoard(),
      },
    );
  }
}
