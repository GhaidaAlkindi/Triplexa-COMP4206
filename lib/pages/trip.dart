import 'package:flutter/material.dart';
import '../model/colorPalette.dart';
import 'package:uitriplexa/sharedWidgets.dart';
import '../model/Trip.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/database_service.dart';

class tripPage extends StatefulWidget {
  final Trip trip;
  const tripPage({super.key, required this.trip});
  @override
  State<tripPage> createState() => tripPageState();
}

class tripPageState extends State<tripPage> {

  final List<IconData> cityIcons = [
    Icons.location_city_rounded, Icons.temple_buddhist_rounded,
    Icons.castle_rounded, Icons.museum_rounded, Icons.mosque_rounded,
  ];

  List<Map<String, dynamic>> cities = [];
  int? _expandedCity;

  final _cityNameCtrl = TextEditingController();
  final _cityDaysCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  @override
  void dispose() {
    _cityNameCtrl.dispose();
    _cityDaysCtrl.dispose();
    super.dispose();
  }

  void _loadCities() {
    // load only cities that belong to this trip
    DatabaseService.citiesRef
        .orderByChild('tripKey')
        .equalTo(widget.trip.firebaseKey)
        .onValue
        .listen((event) {
      if (!mounted) return;
      final data = event.snapshot.value;
      if (data == null) { setState(() => cities = []); return; }
      final map = Map<String, dynamic>.from(data as Map);
      final loaded = map.entries.map((e) {
        final v = Map<String, dynamic>.from(e.value as Map);
        return {
          'firebaseKey': e.key,
          'name':   v['name']   ?? '',
          'days':   v['days']   ?? 1,
          'places': v['places'] ?? 0,
        };
      }).toList();
      setState(() => cities = loaded);
    });
  }

  Future<void> _addCity() async {
    final name = _cityNameCtrl.text.trim();
    final days = int.tryParse(_cityDaysCtrl.text.trim()) ?? 0;
    if (name.isEmpty || days <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a city name and number of days'),
              backgroundColor: Colors.orange, behavior: SnackBarBehavior.floating));
      return;
    }
    try {
      await DatabaseService.citiesRef.push().set({
        'tripKey': widget.trip.firebaseKey,
        'name':    name,
        'days':    days,
        'places':  0,
      });
// update city count on the trip
      await DatabaseService.tripsRef.child(widget.trip.firebaseKey).update({
        'cities': cities.length + 1,
        'days': (cities.fold(0, (sum, c) => sum + (c['days'] as int? ?? 0))) + days,
      });
      _cityNameCtrl.clear();
      _cityDaysCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name added!'),
              backgroundColor: Colorpalette.sageGreen, behavior: SnackBarBehavior.floating));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
    }
  }

  void _deleteCity(Map<String, dynamic> city) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text('Delete "${city['name']}"?',
          style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold)),
      content: const Text('This will remove the city and all its data.',
          style: TextStyle(fontFamily: 'DMSans')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
        TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await DatabaseService.citiesRef.child(city['firebaseKey']).remove();
              //update city count on the trip
              await DatabaseService.tripsRef.child(widget.trip.firebaseKey).update({
                'cities': cities.length - 1,
                'days': cities.fold(0, (sum, c) => sum + (c['days'] as int? ?? 0)) - (city['days'] as int? ?? 0),
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${city['name']}" deleted'),
                      backgroundColor: Colorpalette.warmTerracotta, behavior: SnackBarBehavior.floating));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red))),
      ],
    ));
  }

  Widget addNewCityCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: CustomPaint(
        painter: dashedBorderPainter(color: Colorpalette.sageGreen),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Colorpalette.sageGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.add_circle_outline, color: Colorpalette.sageGreen, size: 20),
              SizedBox(width: 6),
              Text('Add New City', style: TextStyle(fontFamily: 'Nunito', color: Colorpalette.sageGreen,
                  fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(flex: 3,
                    child: TextField(
                      controller: _cityNameCtrl,
                      decoration: InputDecoration(hintText: 'City Name',
                          hintStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)),
                    )),
                const SizedBox(width: 6),
                SizedBox(width: 80,
                    child: TextField(
                      controller: _cityDaysCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Days',
                          hintStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)),
                    )),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  onPressed: _addCity,                          // now connected!
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text('Add', style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colorpalette.sageGreen, elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget cityCard(Map<String, dynamic> city, int cityIndex) {
    var days = city['days'];
    var ic   = cityIcons[cityIndex % cityIcons.length];
    bool exp = _expandedCity == cityIndex;

    return GestureDetector(
      onTap: () => setState(() => _expandedCity = exp ? null : cityIndex),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(ic, color: Colorpalette.steelBlue, size: 22),
            const SizedBox(width: 8),
            Text(city['name'], style: const TextStyle(fontFamily: 'Nunito', fontSize: 20,
                fontWeight: FontWeight.bold, color: Colorpalette.steelBlue)),
            const SizedBox(width: 10),
            Text('${city['days']} days · ${city['places']} places',
                style: const TextStyle(fontFamily: 'DMSans', fontSize: 12, color: Colors.grey)),
            const Spacer(),
            Icon(exp ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                size: 20, color: Colors.grey),
            const SizedBox(width: 4),
            GestureDetector(
                onTap: () => _deleteCity(city),
                child: const Icon(Icons.close, size: 20, color: Colors.grey)),
          ]),

          if (exp) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (int i = 0; i < days; i++)
                GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/dayplanner',
                        arguments: {'cityName': city['name'], 'cityDays': city['days'], 'cityKey': city['firebaseKey']}),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(25)),
                      child: Text('Day ${i + 1}', style: const TextStyle(fontFamily: 'DMSans', color: Colors.grey)),
                    )),
            ]),
          ],
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpalette.cream,
      body: Column(children: [
        Sharedwidgets.buildHeader(widget.trip.name, widget.trip.dates, onClose: () => Navigator.pushReplacementNamed(context, '/home')),
        Expanded(child: ListView(
          padding: const EdgeInsets.only(bottom: 90),
          children: [
            for (int i = 0; i < cities.length; i++)
              cityCard(cities[i], i),
            addNewCityCard(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.ios_share_rounded, size: 18, color: Colors.white),
                  label: const Text('Share Trip', style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colorpalette.warmTerracotta, elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                )),
          ],
        )),
      ]),

      bottomNavigationBar: BottomAppBar(
        color: Colorpalette.warmTerracotta,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
              child: const Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.airplanemode_active_rounded, color: Colors.white60, size: 22),
                Text('Trips', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white60)),
              ])),
          GestureDetector(
              onTap: null,
              child: const Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.location_city_rounded, color: Colors.white, size: 22),
                Text('Cities', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white)),
              ])),
          GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/dayplanner'),
              child: const Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.calendar_month_rounded, color: Colors.white60, size: 22),
                Text('Days', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white60)),
              ])),
        ]),
      ),
    );
  }
}

class dashedBorderPainter extends CustomPainter {
  final Color color; final double strokeWidth; final double radius;
  final double dashWidth; final double dashSpace;
  const dashedBorderPainter({this.color = Colors.grey, this.strokeWidth = 1.5, this.radius = 25, this.dashWidth = 6, this.dashSpace = 4});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = strokeWidth..style = PaintingStyle.stroke;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) { canvas.drawPath(metric.extractPath(d, d + dashWidth), paint); d += dashWidth + dashSpace; }
    }
  }
  @override bool shouldRepaint(covariant CustomPainter o) => false;
}
