
import 'package:flutter/material.dart';

class CheckUserLoginProvider extends ChangeNotifier
{
  //variables
  bool _checkingUserLoggedIn=true;

//getters
  bool get checkingUserLoggedIn => _checkingUserLoggedIn;

//setters



  set checkingUserLoggedIn(bool value) {
    _checkingUserLoggedIn = value;
    notifyListeners();
  }


}
