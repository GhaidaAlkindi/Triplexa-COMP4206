import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'model/colorPalette.dart';
import 'pages/login.dart';
import 'pages/homePage.dart';
import 'pages/trip.dart';
import 'pages/dayPlanner.dart';
import 'model/Trip.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          case '/cities':
            final trip = settings.arguments as Trip?;
            page = tripPage(trip: trip ?? Trip(name:'', dates:'', cities:0, days:0, flag:'', status:'planning'));
            break;
          case '/dayplanner':
            final args = settings.arguments as Map<String, dynamic>?;
            page = dayPlanner(
              cityName: args?['cityName'] ?? 'City',
              cityDays: args?['cityDays'] ?? 1,
              cityKey:  args?['cityKey']  ?? '',
            );
            break;
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
