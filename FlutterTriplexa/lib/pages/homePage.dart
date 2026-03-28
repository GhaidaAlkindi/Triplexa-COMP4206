import 'package:flutter/material.dart';
import 'package:triplexa/pages/trip.dart';
import '../model/colorPalette.dart';
import '../model/Trip.dart';
import '../model/listOfTrips.dart';
import 'package:triplexa/sharedWidgets.dart';
import 'package:triplexa/pages/dayPlanner.dart';

class trips extends StatefulWidget {          //the trips page
  const trips({super.key});
  @override
  State<trips> createState() => tripState();
}

class tripState extends State<trips>{
  int index = 0;

  final List<Trip> tripslist = List.from(listOfTrips);

  Color statusColor(String status){            //a function to return the color baced on the status
    switch(status){
      case 'active': return Colorpalette.sageGreen;
      case 'planning': return Colorpalette.warmTerracotta;
      default: return Colorpalette.steelBlue; } //for the history status
  }

  String statusLabel(String status) {           //return the label
    switch (status) {
      case 'active': return 'Active';
      case 'planning': return 'Planning';
      default: return 'History';
    }
  }

  Widget statisticsSummary(String value, String label){
    return Column(children: [                 //to rpint the top statistics summary
      Text(value,style: const TextStyle(      //print the number
              fontFamily: 'Nunito',fontSize: 17,
              fontWeight: FontWeight.bold, color:Colors.white),),
      Text(label, style: const TextStyle(     //print the stat name
              fontFamily: 'DMSans', fontSize: 15, color: Colors.white)),
    ]); }

  Widget verticalDiv() =>                   //dividing the statistics using a vertical line
      Container(width: 1, height: 26, color: Colorpalette.lightGray);

  Widget headerBar() {
    final cities = 7;                     //to display on top
    final places = 24;

    return Container(                     //the top naviagation bar
      width: double.infinity,             //the whole screen
      decoration: const BoxDecoration(
        color: Colorpalette.steelBlue,    //the bar color
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)), ),
      padding: const EdgeInsets.only(bottom:20),
      child: SafeArea( bottom: false,     //only pad the top
        child: Padding( padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: [ const SizedBox(height: 12),
              Row(                        // a row fo greeting
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ const Column( //column for the greeitng and the user
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning',style: TextStyle(
                              fontFamily: 'Nunito', fontSize: 16,color: Colors.white)),
                      Text('User',style: TextStyle(
                          fontFamily: 'Nunito', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  CircleAvatar( radius: 22, //for the user profile
                    backgroundColor: Colors.white24,
                    child:const Icon(Icons.person, color: Colors.white, size: 26),
                  ), ],
              ),

              const SizedBox(height: 10),     //seperate the greeting from the statistics

              Container(                      //print statistics bar
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration( color: Colors.white12,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [               //print the summary with dividors
                    statisticsSummary('${tripslist.length}','Trips'),
                    verticalDiv(),          //divide between the stats
                    statisticsSummary('$cities','Cities'),
                    verticalDiv(),  statisticsSummary('$places','places'),
                  ],),
              ),
            ],
          ),
        ),
      ),
    );                                      //end of the navigation bar
  }

  Widget statuspill(String status) {        //for the status print: planning, active..
    return Container(                       //pill container
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor(status).withOpacity(0.15), //making the pill transparent
        borderRadius:BorderRadius.circular(30), ),
      child: Text(                          //print the text
        statusLabel(status),
        style: TextStyle(
            fontFamily: 'Nunito', fontSize: 14,fontWeight: FontWeight.bold, color: statusColor(status)),
      ),
    );
  }

  Widget tripContainer(Trip trip){
    return Container(
      //elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration( color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row( children: [
          Text(trip.flag,                 //print the flag
              style:const TextStyle(fontSize: 28)),
          const SizedBox(width: 15),      //space between the flag and the trip content

          Expanded( child: Column(        //for the trip content
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[ Text(trip.name,  //print the country name
                    style: const TextStyle(
                        fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.bold, color: Colorpalette.warmTerracotta)),
                const SizedBox(height: 5),
                Text(                     //print the trip summary
                  '${trip.dates} · ${trip.cities} ${trip.cities == 1 ?'city':'cities'} · ${trip.days } days',
                  style: const TextStyle( fontFamily: 'DMSans', fontSize: 13, color: Colorpalette.steelBlue),
                ),
              ],
            ), ),

          statuspill(trip.status),
          const SizedBox(width: 10),      //spacing from the X mark
          GestureDetector(                //deleting button X to delete the trip
            onTap:() => setState(() => tripslist.remove(trip)),
            child: const Icon(Icons.close,size: 17, color:Colors.grey)),
        ],
      ),
    ); }

  Widget section(String title,List<Trip> items){ //divide section ACTIVE, PLANNING and HISTORY
    if (items.isEmpty) {
      return const SizedBox.shrink(); }           //if no trips in the section we shrink the space
    return Column(                                //else we display
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ Padding(
          padding: const EdgeInsets.only(left: 30, top: 18),
          child: Text(title,                      //print the section TITLE
              style: const TextStyle( fontFamily: 'Nunito', fontSize: 14,
                  fontWeight: FontWeight.w600,    //semibold
                  color: Colors.grey, letterSpacing:1.4)), ),

        for(int i=0; i<items.length;i++)          //print all the trip in the section
          tripContainer(items[i])
      ],
    ); }

  @override                                                               //building the page
  Widget build(BuildContext context) {
    final active = tripslist.where((t) => t.status =='active').toList(); //seperate the trips by their status
    final planning = tripslist.where((t) => t.status =='planning').toList();
    final history= tripslist.where((t) => t.status =='history').toList();

    return Scaffold(
      backgroundColor: Colorpalette.cream,
      body:Column( children: [
        headerBar(),                //display the top bar

          Expanded(                 //display sections and their trips
            child:ListView(
              padding: const EdgeInsets.only(bottom:80),
              children: [
                section('ACTIVE',active),
                section('PLANNING', planning),
                section('HISTORY', history),
              ], ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton( //creating a floating bottun for adding a new trip
        onPressed: (){},
        backgroundColor: Colorpalette.warmTerracotta,
        elevation: 2,                             //shadaow 2
        shape: CircleBorder(),                    //make it circle, full borders
        child:const Icon(Icons.add, color: Colors.white, size: 28)),
      floatingActionButtonLocation:FloatingActionButtonLocation.endFloat,

        bottomNavigationBar: Sharedwidgets.buildFooter(0, (i){ //0 means we highlight the trips tap
          if (i == 1) {
            Navigator.pushReplacement(context,                 //go to trip (city) page
                MaterialPageRoute(builder: (context) => const tripPage()));
          }
          if (i == 2) { Navigator.pushReplacement(context,      //go to day planner
              MaterialPageRoute(builder: (context) => const dayPlanner()));
          }
        })
    );
  }
}
