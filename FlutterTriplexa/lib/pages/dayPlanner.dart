import 'package:flutter/material.dart';
import 'package:triplexa/pages/trip.dart';
import 'package:triplexa/sharedWidgets.dart';
import 'package:triplexa/model/colorPalette.dart';
import 'package:triplexa/pages/homePage.dart';
import 'package:triplexa/pages/addPlace.dart';

class dayPlanner extends StatefulWidget{
  const dayPlanner({super.key});                         //constructor
  @override
  State<dayPlanner> createState() => dayPlannerState();
}
class dayPlannerState extends State<dayPlanner>{

  final int numOfDays = 6;                              //how many days this city has
  int selectedDay = 0;                                  //wich day pill is currently selected

  final List<String> dayDates = [   //the date string for each day
    'Thursday . April 10', 'Friday . April 11', 'Saturday . April 12',
    'Sunday . April 13', 'Monday . April 14', 'Tuesday . April 15', ];

  final List<List<Map<String, dynamic>>> dayPlaces = [  //places grouped by day
    [ {'name': 'Senso-ji Temple','cost': 0,  'type': 'Landmark',  'icon': Icons.temple_buddhist_rounded, 'link': 'maps.google.com', 'note': 'Book tickets in advance to save time and get a discount'},
      {'name': 'Ichiran Ramen',  'cost': 17, 'type': 'Restaurant','icon': Icons.restaurant_rounded,      'link': 'maps.google.com', 'note': ''},
      {'name': 'TeamLab Planets','cost': 23, 'type': 'Activity','icon': Icons.celebration_rounded,     'link': 'maps.google.com', 'note': 'Book tickets in advance to save time and get a discount'}, ],
    [ {'name': 'Shinjuku Gyoen', 'cost': 5,  'type': 'Landmark',   'icon': Icons.park_rounded,            'link': 'maps.google.com', 'note': ''}, ],
    [], [], [], [],                                     //empty days for now
  ];

  Color typeColor(String type){   //bg color for the type tag
    switch(type){
      case 'Landmark':   return Colorpalette.steelBlue.withOpacity(0.15);
      case 'Restaurant': return Colorpalette.warmTerracotta.withOpacity(0.15);
      case 'Activity':   return Colorpalette.sageGreen.withOpacity(0.15);
      case 'Hotel':      return Colorpalette.lightGray.withOpacity(0.4);
      default:           return Colorpalette.cream;
    }}

  Color typeTextColor(String type){  //text color matching the type
    switch(type){
      case 'Landmark':   return Colorpalette.steelBlue;
      case 'Restaurant': return Colorpalette.warmTerracotta;
      case 'Activity':   return Colorpalette.sageGreen;
      case 'Hotel':      return Colorpalette.lightGray;
      default:           return Colors.grey;
    }}

  Widget placeCard(Map<String, dynamic> place, int index){
    final Color tagColor = typeColor(place['type']);
    final Color tagTextColor = typeTextColor(place['type']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(   //the number circle on the left
              width: 26, height: 26,
              decoration: BoxDecoration(color: Colorpalette.steelBlue, shape: BoxShape.circle),
              child: Center(child: Text('${index+1}',
                style: const TextStyle(fontFamily: 'DMSans', fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text('${place['name']} . \$${place['cost']}',  //name and cost
                    style: const TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF444444))),
                  const Spacer(),
                  GestureDetector(   //X to remove the place
                    onTap: (){},
                    child: const Icon(Icons.close, size: 16, color: Colors.grey)),
                ],),
                const SizedBox(height: 6),
                Container(   //type tag with icon
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(place['type'], style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: tagTextColor)),
                    const SizedBox(width: 6),
                    Icon(place['icon'], size: 14, color: tagTextColor),
                  ],),),
                const SizedBox(height: 4),
                if(place['note'] != '')   //only show if there is a note
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text('Note: ${place['note']}',
                      style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),),
                TextButton.icon(   //open in maps link
                  onPressed: (){},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  icon: const Icon(Icons.location_on, size: 15, color: Colorpalette.steelBlue),
                  label: const Text('open location in Google Maps',
                    style: TextStyle(fontFamily: 'DMSans', fontSize: 13, color: Colorpalette.steelBlue)),
                ),
              ],),),
          ],),
      ],);
  }

  @override
  Widget build(BuildContext context) {
    final places = dayPlaces[selectedDay];  //get places for the selected day
    return Scaffold(
      backgroundColor: Colorpalette.cream,
      body: Column(
        children: [
          Sharedwidgets.buildHeader('Tokyo', '6 days . 15 places'),

          const SizedBox(height: 12),

          //horizontal scrollable day pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              for(int i=0; i<numOfDays; i++) ...[
                if(i>0) const SizedBox(width: 8),
                GestureDetector(
                  onTap: ()=> setState(()=> selectedDay = i),  //switch the selected day
                  child: Container(   //day pill
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: i==selectedDay? Colorpalette.steelBlue : Colors.white,  //blue if selected
                      borderRadius: BorderRadius.circular(25)),
                    child: Text('Day ${i+1}',
                      style: TextStyle(fontFamily: 'DMSans', fontWeight: FontWeight.w500,
                        color: i==selectedDay? Colors.white : Colors.grey)),
                  ),)
              ]
            ],)),

          const SizedBox(height: 16),

          Expanded(                                   //big white container for all the days content
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(children: [


                Padding(                              //date text at the top
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Align(alignment: Alignment.centerLeft,
                    child: Text(dayDates[selectedDay],
                      style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500))),),

                Expanded(child: ListView.separated(     //list of places with a divider between each
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: places.length,
                  separatorBuilder: (_,__)=> const Divider(height: 24, color: Colorpalette.cream),
                  itemBuilder: (_,i)=> placeCard(places[i], i),),),


                Padding   (                             //add place button at the bottom
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: ElevatedButton.icon(
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const addPlace())),
                    icon: const Icon(Icons.add_circle_outline, size: 18, color: Colors.white),
                    label: const Text('Add a Place', style: TextStyle(fontFamily: 'Nunito', fontSize: 15,
                      fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colorpalette.steelBlue, elevation: 0,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  ),),

              ],),),),

          const SizedBox(height: 16),
        ],
      ),


        bottomNavigationBar: Sharedwidgets.buildFooter(2, (i){
          if (i == 0) {
            Navigator.pushReplacement(context,              //go to trips
                MaterialPageRoute(builder: (context) => const trips()));
          }
          if (i == 1) { Navigator.pushReplacement(context,  //go to city page
              MaterialPageRoute(builder: (context) => const tripPage()));
          }
        })
    );
  }
}
