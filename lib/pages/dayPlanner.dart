import 'package:flutter/material.dart';
import 'package:uitriplexa/sharedWidgets.dart';
import 'package:uitriplexa/model/colorPalette.dart';
import 'package:uitriplexa/pages/addPlace.dart';

class dayPlanner extends StatefulWidget{
  const dayPlanner({super.key});                                  //constructor
  @override
  State<dayPlanner> createState() => dayPlannerState();          //a state for the day planner
}
class dayPlannerState extends State<dayPlanner>{

  final int numOfDays = 6;                                        //total days for this city
  int selectedDay = 0;                                            //the currnt selected day index
  int navIndex = 2;                                               //days tab is higlighted in the nav bar

  final List<String> dayDates = [                                 //the date for each day
    'Thursday . April 10', 'Friday . April 11', 'Saturday . April 12',
    'Sunday . April 13',   'Monday . April 14', 'Tuesday . April 15', ];

  final List<List<Map<String, dynamic>>> dayPlaces = [            //places for each day
    [ {'name': 'Senso-ji Temple',  'cost': 0,  'type': 'Landmark',   'icon': Icons.temple_buddhist_rounded, 'link': 'maps.google.com', 'note': 'Book tickets in advance to save time and get a discount'},
      {'name': 'Ichiran Ramen',    'cost': 17, 'type': 'Restaurant', 'icon': Icons.restaurant_rounded,      'link': 'maps.google.com', 'note': ''},
      {'name': 'TeamLab Planets',  'cost': 23, 'type': 'Activity',   'icon': Icons.celebration_rounded,     'link': 'maps.google.com', 'note': 'Book tickets in advance to save time and get a discount'}, ],
    [ {'name': 'Shinjuku Gyoen',   'cost': 5,  'type': 'Landmark',   'icon': Icons.park_rounded,            'link': 'maps.google.com', 'note': ''}, ],
    [], [], [], [],
  ];

  Color typeColor(String type){                                   //color for each place type tag
    switch(type){
      case 'Landmark':   return Colorpalette.steelBlue.withOpacity(0.15);
      case 'Restaurant': return Colorpalette.warmTerracotta.withOpacity(0.15);
      case 'Activity':   return Colorpalette.sageGreen.withOpacity(0.15);
      case 'Hotel':      return Colorpalette.lightGray.withOpacity(0.4);
      case 'Transport':  return const Color(0xFF9575CD).withOpacity(0.15);
      case 'Shopping':   return const Color(0xFFFF8A65).withOpacity(0.15);
      default:  return Colorpalette.cream;
    }}

  Color typeTextColor(String type){                               //text/icon color matching the tag background
    switch(type){
      case 'Landmark':   return Colorpalette.steelBlue;
      case 'Restaurant': return Colorpalette.warmTerracotta;
      case 'Activity':   return Colorpalette.sageGreen;
      case 'Hotel':      return Colorpalette.lightGray;
      case 'Transport':  return const Color(0xFF9575CD);
      case 'Shopping':   return const Color(0xFFFF8A65);
      default: return Colors.grey;
    }}

  Future<void> _openPlace(int index) async {                     //tap a place to edit it
    final result = await Navigator.push(context, PageRouteBuilder(
      pageBuilder: (_, __, ___) => addPlace(existingPlace: dayPlaces[selectedDay][index]),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero));
    if (result != null) setState(() => dayPlaces[selectedDay][index] = result);
  }

  Future<void> _addNewPlace() async {                            //add a new place to the day
    final result = await Navigator.push(context, PageRouteBuilder(
      pageBuilder: (_, __, ___) => const addPlace(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero));
    if (result != null) setState(() => dayPlaces[selectedDay].add(result));
  }

  Widget placeCard(Map<String, dynamic> place, int index){
    var tagCol  = typeColor(place['type']);
    var txtCol  = typeTextColor(place['type']);
    var stars   = (place['rating'] as num?)?.toDouble() ?? 0;
    var pri     = place['priority'] ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(                                           //the number circle
              width: 26, height: 26,
              decoration: const BoxDecoration(color: Colorpalette.steelBlue, shape: BoxShape.circle),
              child: Center(child: Text('${index+1}',
                style: const TextStyle(fontFamily: 'DMSans', fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text('${place['name']} · \$${place['cost']}',  //name and cost
                    style: const TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF444444)))),
                  GestureDetector(                               //the X to remove a place
                    onTap: (){},
                    child: const Icon(Icons.close, size: 16, color: Colors.grey)),
                ],),
                const SizedBox(height: 6),
                Row(children: [
                  Container(                                     //the type tag
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: tagCol, borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(place['type'], style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: txtCol)),
                      const SizedBox(width: 6),
                      Icon(place['icon'], size: 14, color: txtCol),
                    ],),),
                  if (pri.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(                                   //priority badge
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colorpalette.cream,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colorpalette.warmTerracotta.withOpacity(0.4))),
                      child: Text(pri, style: const TextStyle(
                        fontFamily: 'DMSans', fontSize: 11, color: Colorpalette.warmTerracotta))),
                  ],
                  if (stars > 0) ...[
                    const Spacer(),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFE8A838)),
                      const SizedBox(width: 3),
                      Text('${stars.toInt()}/5', style: const TextStyle(  //the raing out of 5
                        fontFamily: 'DMSans', fontSize: 12, color: Color(0xFFE8A838), fontWeight: FontWeight.w600)),
                    ]),
                  ],
                ],),
                const SizedBox(height: 4),
                if(place['note'] != null && place['note'] != '') //show the note only if there is one
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text('Note: ${place['note']}',
                      style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),),
                TextButton.icon(                                 //the maps link as a text button
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
    final places = dayPlaces[selectedDay];                        //places for the selected day
    return Scaffold(
      backgroundColor: Colorpalette.cream,                        //specify the background
      body: Column(
        children: [
          Sharedwidgets.buildHeader('Tokyo', '6 days . 15 places'), //call the header from the shared methods

          const SizedBox(height: 12),

          SingleChildScrollView(                                  //horizontal scroll if days dont fit
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              for(int i=0; i<numOfDays; i++) ...[
                if(i>0) const SizedBox(width: 8),
                GestureDetector(
                  onTap: ()=> setState(()=> selectedDay = i),    //select the tapped day
                  child: Container(                              //the day pill
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: i==selectedDay?Colorpalette.steelBlue : Colors.white,  //highlight selected
                      borderRadius: BorderRadius.circular(25)),
                    child: Text('Day ${i+1 }',
                      style: TextStyle(fontFamily: 'DMSans',fontWeight: FontWeight.w500,
                        color: i==selectedDay?Colors.white : Colors.grey)),
                  ),)
              ]
            ],)),

          const SizedBox(height: 16),

          Expanded(                                              //the places container takes the rest of the screen
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(children: [

                Padding(                                         //the date header
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Align(alignment: Alignment.centerLeft,
                    child: Text(dayDates[selectedDay],
                      style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500))),),

                Expanded(child: ListView.separated(             //the list of places
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: places.length,
                  separatorBuilder: (_,__)=> const Divider(height: 24, color: Colorpalette.cream),
                  itemBuilder: (_,i)=> GestureDetector(
                    onTap: () => _openPlace(i),                 //tap a place to edit
                    child: placeCard(places[i], i)),),),

                Padding(                                         //the add a place button
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: ElevatedButton.icon(
                    onPressed: () => _addNewPlace(),
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


        bottomNavigationBar: BottomAppBar(                       //2 means days is active
          color: Colorpalette.warmTerracotta,
          child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(                                   //go to trips
                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                child: const Column( mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.airplanemode_active_rounded, color: Colors.white60, size: 22),
                  Text('Trips', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white60)),
                ])),
              GestureDetector(                                   //go to cities
                onTap: () => Navigator.pushReplacementNamed(context, '/cities'),
                child: const Column( mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.location_city_rounded, color: Colors.white60, size: 22),
                  Text('Cities', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white60)),
                ])),
              GestureDetector(                                   //we are here
                onTap: null,
                child: const Column( mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.calendar_month_rounded, color: Colors.white, size: 22),
                  Text('Days', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white)),
                ])),
            ],
          ),
        )
    );
  }
}
