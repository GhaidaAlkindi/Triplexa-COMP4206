import 'package:flutter/material.dart';
import 'package:triplexa/model/colorPalette.dart';

class addPlace extends StatefulWidget{
  const addPlace({super.key});
  @override
  State<addPlace> createState() => addPlaceState();
}
class addPlaceState extends State<addPlace>{

  String selectedType = 'Landmark';  //default selected type

  //controllers for each input field
  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController mapsLinkController = TextEditingController();
  final TextEditingController notesController = TextEditingController();  //for the notes at the bottom

  final List<Map<String, dynamic>> placeTypes = [  //the 6 types of places
    {'label': 'Landmark',  'icon': Icons.temple_buddhist_rounded, 'color': Colorpalette.steelBlue},
    {'label': 'Restaurant','icon': Icons.restaurant_rounded,      'color': Colorpalette.warmTerracotta},
    {'label': 'Activity',  'icon': Icons.celebration_rounded,     'color': Colorpalette.sageGreen},
    {'label': 'Hotel',     'icon': Icons.hotel_rounded,           'color': Colorpalette.sageGreen},
    {'label': 'Transport', 'icon': Icons.directions_bus_rounded,  'color': Colorpalette.steelBlue},
    {'label': 'Shopping',  'icon': Icons.shopping_bag_rounded,    'color': Colorpalette.warmTerracotta},
  ];

  Widget sectionLabel(String text){           //label above each field
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontFamily: 'Nunito', fontSize: 18,
        fontWeight: FontWeight.w600, color: Colorpalette.steelBlue)),);}

  InputDecoration fieldStyle(String hint){    //reusable style for all input fields
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 15, color: Colors.grey),
      filled: true, fillColor: Colors.white,   //white backgroud for the fields
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border:        OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colorpalette.steelBlue, width: 1.8)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colorpalette.steelBlue, width: 1.8)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colorpalette.steelBlue, width: 2.2)),  //thicker when focused
    );}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpalette.cream,
      body: Column(children: [

        Container(                                                              //header with the page title and sub info
          decoration: const BoxDecoration(
            color: Colorpalette.warmTerracotta,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(35))),  //rounded botom
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 20, right: 20, bottom: 24),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Icon(Icons.apartment_rounded, color: Colors.white, size: 32),  //builing icon
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Add Place', style: TextStyle(fontFamily: 'Nunito', fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white)),
              const Text('Tokyo . Day 1 . Stop 4', style: TextStyle(fontFamily: 'DMSans', fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white70)),  //where this place is being added
            ],),
          ],),),

        //scrollable form
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            //place name field
            sectionLabel('Place Name'),
            TextField(controller: placeNameController,
              style: const TextStyle(fontFamily: 'DMSans', fontSize: 16, fontWeight: FontWeight.w500),
              decoration: fieldStyle('e.g. Mall Of Oman'),),

            const SizedBox(height: 20),


            sectionLabel('Type'),                                           //type selection grid
            GridView.count(
              crossAxisCount: 3, shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),                //disble its own scroll since its inside a scroll view
              crossAxisSpacing: 10,mainAxisSpacing: 10,
              childAspectRatio: 1.8,
              children: [
                for(final t in placeTypes)
                  GestureDetector(
                    onTap: ()=> setState(()=> selectedType = t['label']),  //update the slected type
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedType == t['label']                   //solid if selected, light tint if not
                            ? (t['color'] as Color)
                            : (t['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (t['color'] as Color).withOpacity(selectedType == t['label'] ? 0:0.3),
                          width: 1.5)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(t['icon'], size: 22,
                          color: selectedType == t['label'] ? Colors.white : (t['color'] as Color)),
                        const SizedBox(height: 4),
                        Text(t['label'], style: TextStyle(fontFamily: 'DMSans', fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selectedType == t['label'] ? Colors.white : (t['color'] as Color))),
                      ],),),),
              ],),

            const SizedBox(height: 20),


            sectionLabel('Estimated Cost'),                             //cost field, just a small one with $ next to it
            IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SizedBox(width: 100,
                child: TextField(controller: costController,
                  keyboardType: TextInputType.number,                 //number keyboard
                  style: const TextStyle(fontFamily: 'DMSans', fontSize: 16, fontWeight: FontWeight.w500),
                  decoration: fieldStyle('10'),),),
              const SizedBox(width: 10),
              Center(child: const Text('\$', style: TextStyle(fontFamily: 'Nunito', fontSize: 26, fontWeight: FontWeight.w600, color: Colorpalette.steelBlue))),
            ],),),

            const SizedBox(height: 20),


            sectionLabel('Google Maps Link'),                         //maps link with a paste button next to the field
            IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(child: TextField(controller: mapsLinkController,
                style: const TextStyle(fontFamily: 'DMSans', fontSize: 16, fontWeight: FontWeight.w500),
                decoration: fieldStyle('maps.google.com paste'),),),
              const SizedBox(width: 10),
              ElevatedButton.icon(                                    //paste button, same height as the field
                onPressed: (){},
                icon: const Icon(Icons.content_paste_rounded, size: 16, color: Colors.white),
                label: const Text('Paste', style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colorpalette.steelBlue, elevation: 0,
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),),
            ],),),

            const SizedBox(height: 20),


            sectionLabel('Notes'),                                    //notes multiline field
            TextField(controller: notesController,
              maxLines: 4,                                             //allow multiline input
              style: const TextStyle(fontFamily: 'DMSans', fontSize: 16, fontWeight: FontWeight.w500),
              decoration: fieldStyle('e.g. Extremely cold that day, bring a jacket.\ngo early to avoid crowds...'),),

            const SizedBox(height: 28),

            Row(children: [                                             //save and cancel buttons side by side
              Expanded(child: ElevatedButton.icon(
                onPressed: (){},                                        //will save the place later
                icon: const Icon(Icons.save_rounded, size: 18, color: Colors.white),
                label: const Text('Save', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colorpalette.sageGreen, elevation: 0,
                  minimumSize: const Size(0, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),),),

              const SizedBox(width: 12),

              Expanded(child: ElevatedButton.icon(
                onPressed: ()=> Navigator.pop(context),                  //go back without saving
                icon: const Icon(Icons.cancel_rounded, size: 18, color: Colors.white),
                label: const Text('Cancel', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colorpalette.warmTerracotta, elevation: 0,
                  minimumSize: const Size(0, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),),),
            ],),

            const SizedBox(height: 20),

          ],),),),
      ],),
    );
  }
}
