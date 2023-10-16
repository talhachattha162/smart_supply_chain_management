import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/providers/add_camp.dart';
import 'package:smart_supply_chain_management_fyp/providers/add_grocery.dart';
import 'package:smart_supply_chain_management_fyp/providers/add_medical.dart';
import 'package:smart_supply_chain_management_fyp/providers/checking_user_loggedin.dart';
import 'package:smart_supply_chain_management_fyp/providers/login.dart';
import 'package:smart_supply_chain_management_fyp/providers/requestedLocations.dart';
import 'package:smart_supply_chain_management_fyp/providers/selectrole.dart';
import 'package:smart_supply_chain_management_fyp/providers/signup.dart';
import 'package:smart_supply_chain_management_fyp/screens/welcome_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
          ChangeNotifierProvider<LoginProvider>(
            create: (context) => LoginProvider(),
          ),ChangeNotifierProvider<SignupProvider>(
            create: (context) => SignupProvider(),
          ),ChangeNotifierProvider<SignupRoleProvider>(
            create: (context) => SignupRoleProvider(),
          ),ChangeNotifierProvider<CheckUserLoginProvider>(
            create: (context) => CheckUserLoginProvider(),
          ),ChangeNotifierProvider(
            create: (context) => AddGroceryProvider(),
          ),ChangeNotifierProvider(
            create: (context) => AddMedicalProvider(),
          ),
      ChangeNotifierProvider(
            create: (context) => AddReliefCampProvider(),
          ),
      ChangeNotifierProvider(
            create: (context) => RequestedLocationProvider(),
          ),

        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FYP',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
          ),
          useMaterial3: true,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}
