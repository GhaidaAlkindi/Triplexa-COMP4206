import 'package:flutter/material.dart';
import '../model/colorPalette.dart';
import 'package:uitriplexa/sharedWidgets.dart';

class tripPage extends StatefulWidget{
  const tripPage({super.key});                                    //constructor
  @override
  State<tripPage> createState() => tripPageState();              //a state for the cities page
}
class tripPageState extends State<tripPage>{

  final List<IconData> cityIcons =[                              //each city gets an icon
    Icons.location_city_rounded, Icons.temple_buddhist_rounded,
    Icons.castle_rounded, Icons.museum_rounded,Icons.mosque_rounded,];

  final List<Map<String, dynamic>>cities =[                      //the cities in this trip
    {'name': 'Tokyo', 'days': 6, 'places': 15},
    {'name': 'Osaka', 'days': 11, 'places': 23}, ];

  int? _expandedCity;                                            //index of the expaned city card


  Widget addNewCityCard(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical:8),
      child: CustomPaint(
        painter: dashedBorderPainter(color: Colorpalette.sageGreen), //dashed boder
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colorpalette.sageGreen.withOpacity(0.1),     //a little transparent background
            borderRadius: BorderRadius.circular(25),),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(                                               //a row for the icon then a string
                children: [
                  const Icon(Icons.add_circle_outline, color: Colorpalette.sageGreen,size: 20),
                  const SizedBox(width: 6,),
                  Text('Add New City', style:TextStyle( fontFamily: 'Nunito', color:Colorpalette.sageGreen, fontSize: 16,
                      fontWeight:FontWeight.bold ),)
                ],),
              const SizedBox(height: 10,),

              IntrinsicHeight(                                   //match all children to button height
                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, //stretch fields to fill
                children: [
                  Expanded(                                      //city name takes most of the space
                    flex:3,                                      //3x wider than days field
                    child: TextField(
                      decoration:InputDecoration(hintText: 'City Name', //placeholder text
                        hintStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 12),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled:true,                            //fill the background
                        fillColor:Colors.white,                 //white input background
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),),

                  const SizedBox(width: 6,),
                  SizedBox(width: 80,                            //fixed width so Days doesnt truncate
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration:InputDecoration(hintText: 'Days', //for the number of days
                        hintStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 12),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled:true,                            //fill the background
                        fillColor:Colors.white,                 //white input background
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      ),
                    ),),

                  const SizedBox(width: 6,),
                  ElevatedButton.icon(                           //the add button
                    onPressed: (){},                             //not functional yet
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label:const Text('Add', style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colorpalette.sageGreen, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                  )
              ],),),
            ],
          ),
        ),
      ),
    );
  }

  Widget cityCard(Map<String, dynamic> city, int cityIndex){
    var days = city['days'];
    var ic   = cityIcons[cityIndex % cityIcons.length];
    bool exp = _expandedCity == cityIndex;                       //check if this card is expaned

    return GestureDetector(
      onTap: () => setState(() =>                                //toggl expand on tap
        _expandedCity = exp ? null : cityIndex),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(                                          //extra wrap for the row
              child: Row(children: [
                Icon(ic, color: Colorpalette.steelBlue, size: 22),
                const SizedBox(width: 8),
                Text(city['name'], style: const TextStyle(fontFamily: 'Nunito', fontSize: 20,
                  fontWeight: FontWeight.bold, color: Colorpalette.steelBlue)),
                const SizedBox(width: 10),
                Text('${city['days']} days · ${city['places']} places',
                  style: const TextStyle(fontFamily: 'DMSans', fontSize: 12, color: Colors.grey)),
                const Spacer(),
                Icon(                                           //chevron shows expand state
                  exp ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  size: 20, color: Colors.grey),
                const SizedBox(width: 4),
                GestureDetector(                               //X deletes the city
                  onTap: () => setState(() => cities.remove(city)),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey)),
              ],),
            ),

            if (exp) ...[                                      //day pills appear only when expanded
              const SizedBox(height: 10),
              Wrap(
                spacing: 6, runSpacing: 6,
                children: [
                  for (int i = 0; i < days; i++)
                    GestureDetector(                           //tap a day pill to go to day planner
                      onTap: () => Navigator.pushReplacementNamed(context, '/dayplanner'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25)),
                        child: Text('Day ${i + 1}',
                          style: const TextStyle(fontFamily: 'DMSans', color: Colors.grey)),
                      )),
                ]),
            ],

          ],
        ),
      )); }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpalette.cream,                      //specify the background
      body: Column(
        children: [
          Sharedwidgets.buildHeader('Japan', 'Apr 10-24'),      //call the header from the shared methods
          Expanded(child: ListView(                              //print the city cards
            padding: const EdgeInsets.only(bottom: 90),
            children: [
              for(int i =0; i<cities.length; i++)
                cityCard(cities[i], i),                         //go through each city
                addNewCityCard(),                               //new city form
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: ElevatedButton.icon(                   //share trip button
                    onPressed: (){},
                    icon: const Icon(Icons.ios_share_rounded, size: 18, color: Colors.white),
                    label: const Text('Share Trip', style: TextStyle(fontFamily:'Nunito', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colorpalette.warmTerracotta, elevation:0,
                      minimumSize: const Size(double.infinity,50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  ),)
            ],
          ))

        ],
      ),


      bottomNavigationBar: BottomAppBar(                        //1 means cities is active
        color: Colorpalette.warmTerracotta,
        child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(                                    //go to trips
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
              child: const Column( mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.airplanemode_active_rounded, color: Colors.white60, size: 22),
                Text('Trips', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white60)),
              ])),
            GestureDetector(                                    //we are here
              onTap: null,
              child: const Column( mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.location_city_rounded, color: Colors.white, size: 22),
                Text('Cities', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white)),
              ])),
            GestureDetector(                                    //go to days
              onTap: () => Navigator.pushReplacementNamed(context, '/dayplanner'),
              child: const Column( mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.calendar_month_rounded, color: Colors.white60, size: 22),
                Text('Days', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white60)),
              ])),
          ],
        ),
      ),
    );
  }
}

class dashedBorderPainter extends CustomPainter{              //draws a dashed border
  final Color color; final double strokeWidth; final double radius;
  final double dashWidth; final double dashSpace;
  const dashedBorderPainter({this.color=Colors.grey, this.strokeWidth=1.5, this.radius=25, this.dashWidth=6, this.dashSpace=4});
  @override
  void paint(Canvas canvas, Size size){
    final paint = Paint()..color=color ..strokeWidth=strokeWidth ..style=PaintingStyle.stroke;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0,0,size.width,size.height), Radius.circular(radius)));
    for(final metric in path.computeMetrics()){
      double d=0;
      while(d<metric.length){ canvas.drawPath(metric.extractPath(d, d+dashWidth), paint); d+=dashWidth+dashSpace; }
    }}
  @override bool shouldRepaint(covariant CustomPainter o)=>false;
}
