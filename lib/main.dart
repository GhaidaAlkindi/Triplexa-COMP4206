import 'package:flutter/material.dart';
import 'model/colorPalette.dart';
import 'pages/login.dart';
import 'pages/homePage.dart';
import 'pages/trip.dart';
import 'pages/dayPlanner.dart';

void main() {
  runApp(const UITriplexaApp());
}

class UITriplexaApp extends StatelessWidget{
  const UITriplexaApp({super.key});                      //contructor
  @override
  Widget build(BuildContext context) {
    return MaterialApp(                                  //root widget
      debugShowCheckedModeBanner: false,                 //remove the debug banner
      theme: ThemeData(scaffoldBackgroundColor: Colorpalette.steelBlue, fontFamily: 'DMSans'),
      initialRoute: '/login',                            //start here
      onGenerateRoute: (settings) {                      //genertes routes with no animation
        Widget page;
        switch (settings.name) {
          case '/home':       page = const trips();      break;
          case '/cities':     page = const tripPage();   break;
          case '/dayplanner': page = const dayPlanner(); break;
          default:            page = const login();
        }
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionDuration: Duration.zero,             //no slide animation
          reverseTransitionDuration: Duration.zero,      //no animation going back either
        );
      },
    );
  }
}
