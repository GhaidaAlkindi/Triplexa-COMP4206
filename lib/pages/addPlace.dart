import 'package:flutter/material.dart';
import 'package:uitriplexa/model/colorPalette.dart';

class addPlace extends StatefulWidget {
  final Map<String, dynamic>? existingPlace;                     //null = adding,not null = editing
  const addPlace({super.key, this.existingPlace});
  @override
  State<addPlace> createState() => addPlaceState();
}

class addPlaceState extends State<addPlace> {
  final nameCtrl = TextEditingController();                      //controler for the name field
  final costCtrl = TextEditingController();
  final mapsCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  String selectedType = 'Landmark';                              //default type

  double  _rating      = 3.0;                                   //raing value 1-5
  String  _priority    = 'Must Visit';                          //selectd priority

  bool get isEditing => widget.existingPlace != null;

  final List<String> types      = ['Landmark', 'Restaurant', 'Activity', 'Hotel', 'Transport', 'Shopping'];
  final List<String> priorities = ['Must Visit', 'Nice to Have', 'Optional'];

  @override
  void initState() {
    super.initState();
    if (isEditing) {                                            //fill the fields if editing
      final p = widget.existingPlace!;
      nameCtrl.text = p['name'] ?? '';
      costCtrl.text = p['cost']?.toString() ?? '';
      mapsCtrl.text = p['link'] ?? '';
      noteCtrl.text = p['note'] ?? '';
      selectedType  = p['type'] ?? 'Landmark';
      _rating       = (p['rating'] as num?)?.toDouble() ?? 3.0;
      _priority     = p['priority'] ?? 'Must Visit';
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose(); costCtrl.dispose();
    mapsCtrl.dispose(); noteCtrl.dispose();
    super.dispose();
  }

  void save() {
    if (nameCtrl.text.trim().isEmpty) return;                   //dont save empty name
    final place = {
      'name':      nameCtrl.text.trim(),
      'cost':      int.tryParse(costCtrl.text.trim()) ?? 0,
      'link':      mapsCtrl.text.trim(),
      'note':      noteCtrl.text.trim(),
      'type':      selectedType,
      'icon':      typeIcon(selectedType),
      'rating':    _rating,
      'priority':  _priority,
    };
    Navigator.pop(context, place);                              //return the place to dayPlanner
  }

  IconData typeIcon(String type) {
    switch(type) {
      case 'Landmark':   return Icons.temple_buddhist_rounded;
      case 'Restaurant': return Icons.restaurant_rounded;
      case 'Activity':   return Icons.celebration_rounded;
      case 'Hotel':      return Icons.hotel_rounded;
      case 'Transport':  return Icons.directions_transit_rounded;
      case 'Shopping':   return Icons.shopping_bag_rounded;
      default:           return Icons.place_rounded;
    }}

  Color typeColor(String type) {
    switch(type) {
      case 'Landmark':   return Colorpalette.steelBlue;
      case 'Restaurant': return Colorpalette.warmTerracotta;
      case 'Activity':   return Colorpalette.sageGreen;
      case 'Hotel':      return const Color(0xFFE8A838);        //warm amber
      case 'Transport':  return const Color(0xFF9575CD);        //soft purple
      case 'Shopping':   return const Color(0xFFFF8A65);        //soft orange
      default:           return Colors.grey;
    }}

  String typeEmoji(String type) {
    switch(type) {
      case 'Landmark':   return '🏛';
      case 'Restaurant': return '🍜';
      case 'Activity':   return '🎨';
      case 'Hotel':      return '🏨';
      case 'Transport':  return '🚇';
      case 'Shopping':   return '🛍';
      default:           return '📍';
    }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpalette.cream,
      body: Column(children: [

        Container(                                              //the top header
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colorpalette.steelBlue,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(35))),
          padding: const EdgeInsets.only(bottom: 20),
          child: SafeArea(bottom: false,
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  GestureDetector(                              //back to day planner
                    onTap: () => Navigator.pop(context),
                    child: const Row(children: [
                      Icon(Icons.arrow_back_ios_rounded, color: Colors.white70, size: 14),
                      SizedBox(width: 4),
                      Text('Day Planner', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, color: Colors.white70)),
                    ])),
                  const SizedBox(height: 8),
                  Text(isEditing ? 'Edit Place' : 'Add a Place',
                    style: const TextStyle(fontFamily: 'Nunito', fontSize: 26,
                      fontWeight: FontWeight.bold, color: Colors.white)),
                ])))),

        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              placeLabel('PLACE NAME'),
              placeField(nameCtrl, 'e.g. Senso-ji Temple'),

              placeLabel('TYPE'),
              GridView.count(                                   //type selector grid 2x3
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 6, mainAxisSpacing: 6,
                childAspectRatio: 1.6,                         //wider than tall
                padding: const EdgeInsets.only(bottom: 14),
                children: types.asMap().entries.map((entry) {
                  var i = entry.key;
                  var t = entry.value;
                  bool sel = selectedType == t;
                  var col = [Colorpalette.steelBlue, Colorpalette.warmTerracotta, Colorpalette.sageGreen][i % 3]; //cycle colors
                  return GestureDetector(
                    onTap: () => setState(() => selectedType = t),
                    child: Container(
                      decoration: BoxDecoration(
                        color: sel ? col : Colors.white,           //only selected is filled
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: col, width: 2)), //always colored boder
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(typeEmoji(t), style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 5),
                          Text(t, style: TextStyle(fontFamily: 'DMSans', fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : col)),
                        ])));
                }).toList()),

              placeLabel('RATING'),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: SliderTheme(                 //pill-shaped track
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                      activeTrackColor: Colorpalette.warmTerracotta,
                      inactiveTrackColor: Colors.white,        //unrated part is white
                      thumbColor: Colorpalette.warmTerracotta,
                      overlayColor: Colorpalette.warmTerracotta.withOpacity(0.15),
                    ),
                    child: Slider(
                      value: _rating,
                      min: 1, max: 5, divisions: 4,
                      onChanged: (val) => setState(() => _rating = val),
                    ))),
                  const SizedBox(width: 8),
                  Container(                                   //circle badge for the rating number
                    width: 36, height: 36,
                    decoration: const BoxDecoration(
                      color: Colorpalette.warmTerracotta,
                      shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text('${_rating.toInt()}',
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 16,
                        fontWeight: FontWeight.bold, color: Colors.white))),
                ])),

              placeLabel('PRIORITY'),
              Column(                                          //radio buttons blended with the bg
                children: priorities.map((p) => RadioListTile<String>(
                  value: p,
                  groupValue: _priority,
                  activeColor: Colorpalette.warmTerracotta,
                  dense: true,
                  title: Text(p, style: const TextStyle(
                    fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w600, color: Colorpalette.steelBlue)),
                  onChanged: (val) => setState(() => _priority = val!),
                )).toList()),
              const SizedBox(height: 6),

              placeLabel('ESTIMATED COST'),
              IntrinsicHeight(                                 //make OMR box match the field height
                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Expanded(flex: 3, child: placeField(costCtrl, '0',
                    keyboard: const TextInputType.numberWithOptions(decimal: false), bottomPad: 0)),
                  const SizedBox(width: 8),
                  Container(                                   //OMR label next to cost
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200)),
                    child: const Text('OMR', style: TextStyle(
                      fontFamily: 'DMSans', fontWeight: FontWeight.w600,
                      color: Colorpalette.warmTerracotta))),
                ])),
              const SizedBox(height: 14),

              placeLabel('GOOGLE MAPS LINK'),
              placeField(mapsCtrl, 'maps.google.com...'),

              placeLabel('NOTES'),
              placeField(noteCtrl, 'e.g. Book in advance, go early to avoid crowds...', maxLines: 3),
              const SizedBox(height: 18),

              Row(children: [                                  //save and cancel buttons
                Expanded(child: ElevatedButton.icon(
                  onPressed: save,
                  icon: const Icon(Icons.save_rounded, color: Colors.white, size: 18),
                  label: const Text('Save', style: TextStyle(fontFamily: 'Nunito',
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colorpalette.sageGreen, elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                  label: const Text('Cancel', style: TextStyle(fontFamily: 'Nunito',
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colorpalette.warmTerracotta, elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))))),
              ]),
              const SizedBox(height: 20),
            ]))),

      ]));
  }

  Widget placeLabel(String txt) =>                             //label above each field
    Padding(padding: const EdgeInsets.only(bottom: 6, top: 2),
      child: Text(txt, style: const TextStyle(fontFamily: 'Nunito', fontSize: 13,
        fontWeight: FontWeight.bold, color: Colorpalette.warmTerracotta)));

  Widget placeField(TextEditingController c, String hint, {TextInputType? keyboard, int maxLines = 1, double bottomPad = 14}) =>
    Padding(padding: EdgeInsets.only(bottom: bottomPad),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        maxLines: maxLines,
        style: const TextStyle(fontFamily: 'DMSans', color: Color(0xFF444444)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: Colors.grey),
          filled: true, fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colorpalette.warmTerracotta, width: 2)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colorpalette.warmTerracotta, width: 2)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colorpalette.warmTerracotta, width: 2.8)))));
}
