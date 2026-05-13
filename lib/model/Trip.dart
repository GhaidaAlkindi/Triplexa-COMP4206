import 'package:flutter/material.dart';
class Trip {                    //for the trips the user has
  final String name;
  final String dates;
  final int cities;
  final int days;
  final String flag;
  final String status;        //each trip is a planning, or active or history trip
  final String imageUrl;      //network photo (existing trips)
  final String imagePath;     //local file photo (user-picked from gallery)
  final String firebaseKey;   //link the database
  Trip({required this.name,required this.dates,required this.cities,
    required this.days, required this.flag,required this.status,
    this.imageUrl = '', this.imagePath = '', this.firebaseKey= '',
  });
}
