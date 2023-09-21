
import 'package:flutter/material.dart';

class AddGroceryProvider extends ChangeNotifier
{

  String? _selectedStatus;
  bool _hasDeliveryServices=false;
  String? _selectedStoreType;
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
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

  String? get selectedStatus => _selectedStatus;

  set selectedStatus(String? value) {
    _selectedStatus = value;
    notifyListeners();
  }


  bool get hasDeliveryServices => _hasDeliveryServices;

  set hasDeliveryServices(bool value) {
    _hasDeliveryServices = value;
    notifyListeners();
  }

  String? get selectedStoreType => _selectedStoreType;

  set selectedStoreType(String? value) {
    _selectedStoreType = value;
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
