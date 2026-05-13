import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static final _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://triplexa-7835a-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();

  // get current user id
  static String get uid => FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

  // user-scoped references — each user has their own data
  static DatabaseReference get tripsRef  => _db.child('users/$uid/trips');
  static DatabaseReference get citiesRef => _db.child('users/$uid/cities');
  static DatabaseReference get placesRef => _db.child('users/$uid/places');
}