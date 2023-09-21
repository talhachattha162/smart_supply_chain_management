
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier
{
  //variables
bool _isLoading=false;
bool _obscurePass=true;

//getters
bool get isLoading => _isLoading;
bool get obscurePass => _obscurePass;

//setters

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }



  set obscurePass(bool value) {
    _obscurePass = value;
    notifyListeners();
  }

}
