import 'dart:io';
import 'dart:math';

//Enumrations
enum PlaceType {Landmark, resturant, activity,hotel, transport, shopping}

//Mixin
mixin Displayable {
  void printLine() => print('-' * 40);
}

//ID generator
String generateId(String prefix) {
  final rand = Random();
  return '$prefix-${rand.nextInt(90000) + 10000}';
}

//Trip Class
class Trip with Displayable{
  String _tripID;
  String _userID;
  String _startD;
  String _endD;
  String _status;
  String _tripName;
  String _country;
  
  Trip({
    required String userID,
    required String tripName,
    required String country,
    required String startDate,
    required String endDate,
    String status = 'planning',
    String? tripID,
  })
  :_tripID = tripID ?? generateId("TRP"),
   _startD = startDate,
   _endD = endDate,
   _userID = userID,
   _status = status,
   _tripName = tripName,
   _country = country;

  //Getters
  String get tripID => _tripID;
  String get userID => _userID;
  String get tripName => _tripName;
  String get startD => _startD;  
  String get endD => _endD;
  String get status => _status;
  String get country => _country;

  set tripName(String v) {
    if (v.trim().isEmpty) throw ArgumentError('Trip name cannot be empty.');
    _tripName = v.trim();
  }
  
  
  set status(String st) {
    if (!['planning', 'active', 'completed'].contains(st))
      throw ArgumentError('Invalid status.');
    _status = st;
  }

  void display() {
    printLine();
    print('  Trip ID     :$_tripID');
    print('  User ID     :$_userID');
    print('  Trip Name   :$_tripName');

    print('  Dates       :$_startD > $_endD');
    print('  Status      :$_status');
    printLine();
  }
}

//City class
class City with Displayable {
  String _cityId;
  String _tripId;
  String _cityName;
  int _daysCount;

  //city counstructor
  City({
    required String tripId,
    required String cityName,
    required int daysCount,
    String? cityId,
  })  : _cityId = cityId ?? generateId('CTY'),
        _tripId = tripId,
        _cityName = cityName,
        _daysCount = daysCount;

  //Getters
  String get cityId => _cityId;
  String get tripId => _tripId;
  String get cityName => _cityName;
  int get daysCount => _daysCount;

  set daysCount(int v) {
    if (v <= 0) throw ArgumentError('Days must be positive.');
    _daysCount = v;
  }

  void display() {
    printLine();
    print('  City ID     : $_cityId');
    print('  Trip ID     : $_tripId');
    print('  City Name   : $_cityName');
    print('  Days Count  : $_daysCount');
    printLine();
  }
}

//Places class
class Place with Displayable {
  String _placeId;
  String _cityId;
  String _placeName;
  int _dayNumber;
  PlaceType _category;
  double _cost;
  String? _mapsLink;
  String? _notes;

  // Place constructor
  Place({
    required String cityId,
    required String placeName,
    required int dayNumber,
    required PlaceType category,
    required double cost,
    String? mapsLink,
    String? notes,
    String? placeId,
  })  : _placeId = placeId ?? generateId('PLC'),
        _cityId = cityId,
        _placeName = placeName,
        _dayNumber = dayNumber,
        _category = category,
        _cost = cost,
        _mapsLink = mapsLink,
        _notes = notes;

  //Getters
  String get placeId => _placeId;
  String get cityId => _cityId;
  String get placeName => _placeName;
  int get dayNumber => _dayNumber;
  PlaceType get category => _category;
  double get cost => _cost;
  String? get mapsLink => _mapsLink;
  String? get notes => _notes;

  
  set placeName(String v) {
    if (v.trim().isEmpty) throw ArgumentError('Place name can not be empty');
    _placeName = v.trim();
  }

  set cost(double v) {
    if (v < 0) throw ArgumentError('Cost can not be negative');
    _cost = v;
  }

  set notes(String? v) => _notes = v;
  set mapsLink(String? v) => _mapsLink = v;

  void display() {
    printLine();
    print('  Place ID    :$_placeId');
    print('  City ID     :$_cityId');
    print('  Place Name  :$_placeName');
    print('  Day Number  :$_dayNumber');
    print('  Category    :${_category.name}');
    print('  Cost        :\$$_cost');
    if (_mapsLink != null) print('  Maps Link   :$_mapsLink');
    if (_notes != null) print(' Notes       :$_notes');
    printLine();
  }
}

// ─── LISTS ───────────────────────────────────
List<Trip> trips = [];
List<City> cities = [];
List<Place> places = [];

// ─── MAPS (ID > Object) ──────────────────────
Map<String, Trip> tripMap = {};
Map<String, City> cityMap = {};
Map<String, Place> placeMap = {};

// ─── SYNC MAPS ───────────────────────────────
void syncMaps() {
  tripMap  = {for (var t in trips)  t.tripID : t};
  cityMap  = {for (var c in cities) c.cityId : c};
  placeMap = {for (var p in places) p.placeId : p};
}

//Input helpers
String readLine({String prompt = ''}) {
  stdout.write(prompt);
  return stdin.readLineSync()?.trim() ?? '';
}

int? readInt({String prompt = ''}) {
  final input = readLine(prompt: prompt);
  return int.tryParse(input);
}

double? readDouble({String prompt = ''}) {
  final input = readLine(prompt: prompt);
  return double.tryParse(input);
}

//Main Menu
void printMenu() {
  print('''
╔══════════════════════════════════════╗
║        TRIPLEXA CONSOLE APP          ║
╠══════════════════════════════════════╣
║  1. Display All Trips                ║
║  2. Display All Cities               ║
║  3. Display All Places               ║
╠══════════════════════════════════════╣
║  4. Add Trip                         ║
║  5. Add City                         ║
║  6. Add Place                        ║
╠══════════════════════════════════════╣
║  7. Delete Trip                      ║
║  8. Delete City                      ║
║  9. Delete Place                     ║
╠══════════════════════════════════════╣
║  0. Exit                             ║
╚══════════════════════════════════════╝''');
}

//Main Class
void main() {
  while (true) {
    try {
      printMenu();
      final choice = readInt(prompt: '\n  Enter choice: ');

      if (choice == null) {
        print('  ❌ Please enter a valid number.');
        continue;
      }

      switch (choice) {
        case 0: print('\n  👋 Goodbye!\n'); exit(0);
        case 1: displayAllTrips();  break;
        case 2: displayAllCities(); break;
        case 3: displayAllPlaces(); break;
        case 4: addTrip();          break;
        case 5: addCity();          break;
        case 6: addPlace();         break;
        case 7: deleteTrip();       break;
        case 8: deleteCity();       break;
        case 9: deletePlace();      break;
        default: print('  ❌ Invalid option. Choose 0–9.');
      }
    } catch (e) {
      print('  ❌ Unexpected error: $e');
    }
  }
}


//DISPLAY FUNCTIONS 


//Display trips
void displayAllTrips() {
  print('\n   ALL TRIPS (${trips.length})');
  if (trips.isEmpty) {
    print('  No trips found.');
    return;
  }
  for (final t in trips) {
    t.display();
  }
}

//Display cities
void displayAllCities() {
  print('\n   ALL CITIES (${cities.length})');
  if (cities.isEmpty) {
    print('  No cities found.');
    return;
  }
  for (final c in cities) {
    c.display();
  }
}

//Display places
void displayAllPlaces() {
  print('\n  ALL PLACES (${places.length})');
  if (places.isEmpty) {
    print('  No places found.');
    return;
  }
  for (final p in places) {
    p.display();
  }
}

//ADD Functions

    void addTrip() {
      print('\n   ADD TRIP');
      try {
        final userId   = readLine(prompt: '  User ID     : ');
        final tripName = readLine(prompt: '  Trip Name   : ');
        final country  = readLine(prompt: '  Country     : ');
        final startDate = readLine(prompt: '  Start Date  : ');
        final endDate   = readLine(prompt: '  End Date    : ');
        print('  Status options: 1) planning  2) active  3) completed');
        final statusInput = readInt(prompt: '  Choose (1-3): ') ?? 1;
        final statusOptions = ['planning', 'active', 'completed'];
        final status = statusOptions[(statusInput.clamp(1, 3)) - 1];

        if (userId.isEmpty || tripName.isEmpty || country.isEmpty)
          throw ArgumentError('User ID, Trip Name and Country cannot be empty.');

        final trip = Trip(
          userID: userId,
          tripName: tripName,
          country: country,
          startDate: startDate,
          endDate: endDate,
          status: status,
        );

        trips.add(trip);
        syncMaps();
        print('  Trip added! ID: ${trip.tripID}');
      } catch (e) {
        print('  Error: $e');
      }
    }

    void addCity() {
      print('\n  ADD CITY');
      try {
        displayAllTrips();
        final tripId   = readLine(prompt: '  Trip ID     : ');
        if (!tripMap.containsKey(tripId))
          throw Exception('Trip ID "$tripId" not found.');

        final cityName  = readLine(prompt: '  City Name   : ');
        final daysCount = readInt(prompt: '  Days Count  : ') ?? 0;
        if (daysCount <= 0) throw ArgumentError('Days must be positive.');

        final city = City(
          tripId: tripId,
          cityName: cityName,
          daysCount: daysCount,
        );

        cities.add(city);
        syncMaps();
        print('  City added! ID: ${city.cityId}');
      } catch (e) {
        print('  Error: $e');
      }
    }


    void addPlace() {
      print('\n   ADD PLACE');
      try {
        displayAllCities();
        final cityId = readLine(prompt: '  City ID     : ');
        if (!cityMap.containsKey(cityId))
          throw Exception('City ID "$cityId" not found.');

        final placeName = readLine(prompt: '  Place Name  : ');
        final dayNumber = readInt(prompt: '  Day Number  : ') ?? 1;

        print('  Categories: 1)Landmark 2)Restaurant 3)Activity 4)Hotel 5)Transport 6)Shopping');
        final catInput = readInt(prompt: '  Choose (1-6): ') ?? 1;
        final category = PlaceType.values[(catInput.clamp(1, 6)) - 1];

        final cost     = readDouble(prompt: '  Cost (\$)    : ') ?? 0.0;
        final mapsLink = readLine(prompt: '  Maps Link   : ');
        final notes    = readLine(prompt: '  Notes       : ');

        final place = Place(
          cityId: cityId,
          placeName: placeName,
          dayNumber: dayNumber,
          category: category,
          cost: cost,
          mapsLink: mapsLink.isEmpty ? null : mapsLink,
          notes: notes.isEmpty ? null : notes,
        );

        places.add(place);
        syncMaps();
        print('  Place added! ID: ${place.placeId}');
      } catch (e) {
        print('  Error: $e');
      }
    }

//Delete Functions
void deleteTrip() {
  print('\n  DELETE TRIP');
  try {
    displayAllTrips();
    if (trips.isEmpty) return;

    final id = readLine(prompt: '  Enter Trip ID to delete: ');
    if (!tripMap.containsKey(id))
      throw Exception('Trip ID "$id" not found.');

    final trip = tripMap[id]!;
    print('  Are you sure you want to delete "${trip.tripName}"?');
    final confirm = readLine(prompt: '  Type YES to confirm: ');

    if (confirm == 'YES') {
      trips.remove(trip);
      syncMaps();
      print('  Trip deleted successfully.');
    } else {
      print('  Deletion cancelled.');
    }
  } catch (e) {
    print('  Error: $e');
  }
}

void deleteCity() {
  print('\n  DELETE CITY');
  try {
    displayAllCities();
    if (cities.isEmpty) return;

    final id = readLine(prompt: '  Enter City ID to delete: ');
    if (!cityMap.containsKey(id))
      throw Exception('City ID "$id" not found.');

    final city = cityMap[id]!;
    print('  Are you sure you want to delete "${city.cityName}"?');
    final confirm = readLine(prompt: '  Type YES to confirm: ');

    if (confirm == 'YES') {
      cities.remove(city);
      syncMaps();
      print('  City deleted successfully.');
    } else {
      print('  Deletion cancelled.');
    }
  } catch (e) {
    print('  Error: $e');
  }
}
void deletePlace() {
  print('\n  DELETE PLACE');
  try {
    displayAllPlaces();
    if (places.isEmpty) return;

    final id = readLine(prompt: '  Enter Place ID to delete: ');
    if (!placeMap.containsKey(id))
      throw Exception('Place ID "$id" not found.');

    final place = placeMap[id]!;
    print('  Are you sure you want to delete "${place.placeName}"?');
    final confirm = readLine(prompt: '  Type YES to confirm: ');

    if (confirm == 'YES') {
      places.remove(place);
      syncMaps();
      print('  Place deleted successfully.');
    } else {
      print('  Deletion cancelled.');
    }
  } catch (e) {
    print('  Error: $e');
  }
}