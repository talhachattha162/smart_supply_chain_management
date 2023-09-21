
import 'package:flutter/material.dart';

class SignupRoleProvider extends ChangeNotifier
{

  String? _selectedRole;

  String? get selectedRole => _selectedRole;

  set selectedRole(String? value) {
    _selectedRole = value;
    notifyListeners();
  }


}
