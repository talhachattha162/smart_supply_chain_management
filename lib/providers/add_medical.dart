
import 'package:flutter/material.dart';

class AddMedicalProvider extends ChangeNotifier
{


  String? _selectedStatus;
  String? _selectedFacilityType;
  String _location='';

  String get location => _location;

  set location(String value) {
    _location = value;
    notifyListeners();
  }

  double _latitude=0.0;
  double _longitude=0.0;

  String? get selectedFacilityType => _selectedFacilityType;

  set selectedFacilityType(String? value) {
    _selectedFacilityType = value;
    notifyListeners();
  }

  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
  bool _isLoading=false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? get selectedStatus => _selectedStatus;

  set selectedStatus(String? value) {
    _selectedStatus = value;
    notifyListeners();
  }


  DateTime? get selectedStartTime => _selectedStartTime;

  set selectedStartTime(DateTime? value) {
    _selectedStartTime = value;
    notifyListeners();
  }

  DateTime? get selectedEndTime => _selectedEndTime;

  set selectedEndTime(DateTime? value) {
    _selectedEndTime = value;
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
