import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/providers/add_grocery.dart';
import 'package:smart_supply_chain_management_fyp/providers/user.dart';
import 'package:smart_supply_chain_management_fyp/screens/admin/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/forgot_password_screen.dart';
import 'package:smart_supply_chain_management_fyp/screens/grocery_store_manager/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_manager/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_manager/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_worker/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/select_role.dart';
import 'package:smart_supply_chain_management_fyp/screens/signup_screen.dart';

import '../firebase/firebase_auth.dart';
import '../models/user.dart';
import '../providers/login.dart';
import '../providers/selectrole.dart';
import '../providers/signup.dart';
import '../utils/theme.dart';
import 'donor/main.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Form(
                      key: _formKey, // Assign the form key to the form
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // SizedBox(height: height*0.02),
                              Image.asset(
                                width: width,
                                'lib/assets/gifs/login.gif',
                                height: height * 0.3,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal:2.0,vertical:height*0.01), //
                                  border: UnderlineInputBorder(),
                                  labelText: 'Email',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                keyboardType: TextInputType
                                    .emailAddress, // Specify keyboard type
                                validator: (value) {
                                  String? email = value?.trim();
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b').hasMatch(email!)) {
                                    return 'Enter valid email';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value!;
                                },
                              ),
                              // SizedBox(height: height*0.01),
                              Selector<LoginProvider,bool>(
                                selector: (p0, p1) => p1.obscurePass,
                                builder: (_, obscurePass, child) => TextFormField(
                                  obscureText: obscurePass,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal:2.0,vertical:height*0.01), //
                                    suffixIcon: IconButton(
                                      onPressed: () {
Provider.of<LoginProvider>(context,listen: false).obscurePass=!Provider.of<LoginProvider>(context,listen: false).obscurePass;
                                      },
                                      icon: obscurePass?Icon(Icons.visibility):Icon(Icons.visibility_off),
                                    ),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Password',
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  validator: (value) {
                                    if(value!=null){
                                      String password = value!;
                                      if (password.length < 8) {
                                        return 'Password must be at least 8 characters';
                                      }
                                      if (!RegExp(r'[A-Z]').hasMatch(password)) {
                                        return 'Include at least 1 uppercase letter';
                                      }
                                      if (!RegExp(r'[a-z]').hasMatch(password)) {
                                        return 'Include at least 1 lowercase letter';
                                      }
                                      if (!RegExp(r'\d').hasMatch(password)) {
                                        return 'Include at least 1 digit';
                                      }
                                      if (!RegExp(r'\W').hasMatch(password)) {
                                        return 'Include at least 1 special character';
                                      }
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    _password = value!;
                                  },

                                ),
                              ),
                              SizedBox(height: height * 0.04),
                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    Provider.of<LoginProvider>(context,
                                            listen: false)
                                        .isLoading = true;

                                    AuthService auth = AuthService();
                                    try {
                                      UserModel? user = await auth.loginUser(
                                          _email, _password);

                                      if (user != null) {
                                        UserProvider.userModel = user;
                                        if (user.userRole == 'Admin') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AdminMain(),
                                            ),
                                          );
                                        } else if (user.userRole ==
                                            'Resident') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ResidentMain(),
                                            ),
                                          );
                                        } else if (user.userRole ==
                                            'Grocery Store Manager') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  GroceryStoreManagerMain(),
                                            ),
                                          );
                                        } else if (user.userRole ==
                                            'Medical Facility Manager') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MedicalManagerMain(),
                                            ),
                                          );
                                        } else if (user.userRole ==
                                            'Relief Camp Manager') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReliefCampManagerMain(),
                                            ),
                                          );
                                        } else if (user.userRole ==
                                            'Relief Worker') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReliefWorkerMain(),
                                            ),
                                          );
                                        }
                                        else if (UserProvider.userModel!.userRole == 'Donor') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DonorMain(),
                                            ),
                                          );
                                        }

                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Try different role')));
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text('$e')));
                                    }
                                    Provider.of<LoginProvider>(context,
                                            listen: false)
                                        .isLoading = false;
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: button_color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    border: Border.all(
                                      color: button_color, // Border color
                                      width: 2.0, // Border width
                                    ),
                                  ),
                                  height: height * 0.07,
                                  width: width,
                                  child: Center(
                                      child: Selector<LoginProvider, bool>(
                                          selector: (p0, p1) => p1.isLoading,
                                          builder: (_, isLoading, child) {
                                            return isLoading
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Text('Login',
                                                    style: TextStyle(
                                                        color: Colors.white));
                                          })),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordScreen(),
                                        ));
                                  },
                                  child: Text('Forgot Password?',
                                      style: TextStyle(color: button_color))),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                      SelectRole()
                                      ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    border: Border.all(
                                      color: button_color, // Border color
                                      width: 2.0, // Border width
                                    ),
                                  ),
                                  height: height * 0.07,
                                  width: width,
                                  child: const Center(
                                      child: Text('Create New Account',
                                          style:
                                              TextStyle(color: button_color))),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

    );
  }
}
