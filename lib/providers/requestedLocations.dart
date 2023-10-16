import 'package:flutter/cupertino.dart';

class RequestedLocationProvider extends ChangeNotifier{
  double _latitude=0.0;

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  double _longitude=0.0;

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }
}