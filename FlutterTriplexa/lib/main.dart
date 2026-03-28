import 'package:flutter/material.dart';
import 'model/colorPalette.dart';
import 'pages/login.dart';

void main() {
  runApp(const TriplexaApp());
}

class TriplexaApp extends StatelessWidget{
  const TriplexaApp({super.key});         //contructor
  @override
  Widget build(BuildContext context) {
    return MaterialApp(                   //root widget
      debugShowCheckedModeBanner: false,  //remove the debug banner
      theme: ThemeData(scaffoldBackgroundColor: Colorpalette.steelBlue, fontFamily: 'DMSans'),
      home: login(),                      //start by opening the login page
    );
  }
}
