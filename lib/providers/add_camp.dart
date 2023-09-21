
import 'package:flutter/material.dart';

class AddReliefCampProvider extends ChangeNotifier
{
  
  bool _isLoading=false;
  String _location='';

  String get location => _location;

  set location(String value) {
    _location = value;
    notifyListeners();
  }

  double _latitude=0.0;
  double _longitude=0.0;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
    notifyListeners();
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
    notifyListeners();
  }
}
