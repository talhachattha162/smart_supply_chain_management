import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/screens/login_screen.dart';
import 'package:smart_supply_chain_management_fyp/providers/user.dart';
import 'package:smart_supply_chain_management_fyp/screens/admin/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/grocery_store_manager/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_manager/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_manager/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_worker/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/select_role.dart';
import '../clippers/welcome_clipper.dart';
import '../firebase/firebase_auth.dart';
import '../models/user.dart';
import '../providers/add_grocery.dart';
import '../providers/checking_user_loggedin.dart';
import '../providers/login.dart';
import '../providers/selectrole.dart';
import '../providers/user.dart';
import '../utils/theme.dart';
import 'donor/main.dart';
import 'medical_manager/main.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getUserLoggedInHelper();
    });
  }

  Future<UserModel?> getUserLoggedIn() async {
    AuthService auth = AuthService();
    UserModel? userModel = await auth.getUserLoggedin();
    return userModel;
  }

  getUserLoggedInHelper() async {
    UserProvider.userModel = await getUserLoggedIn();
    if (UserProvider.userModel != null) {
      if (UserProvider.userModel!.userRole == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminMain(),
          ),
        );
      } else if (UserProvider.userModel!.userRole == 'Resident') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResidentMain(),
          ),
        );
      } else if (UserProvider.userModel!.userRole == 'Grocery Store Manager') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GroceryStoreManagerMain(),
          ),
        );
      } else if (UserProvider.userModel!.userRole ==
          'Medical Facility Manager') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MedicalManagerMain(),
          ),
        );
      } else if (UserProvider.userModel!.userRole == 'Relief Camp Manager') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReliefCampManagerMain(),
          ),
        );
      }
      else if (UserProvider.userModel!.userRole == 'Relief Worker') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReliefWorkerMain(),
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
    }
    else{
      Provider.of<CheckUserLoginProvider>(context,listen: false).checkingUserLoggedIn = false;
      print('talha1');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(body:
    Selector<CheckUserLoginProvider, bool>(
        selector: (p0, p1) => p1.checkingUserLoggedIn,
        builder: (_, checkingUserLoggedIn, child) => checkingUserLoggedIn
            ? Center(
          child: CircularProgressIndicator(),
        )
            :  Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
                ClipPath(
                  clipper: BezierClipper(),
                  child: Container(
                    color: container_color,
                    height: height*0.4,
                    child: Center(
                      child:
                    Text('Welcome',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                SizedBox(height: height*0.09,),
                InkWell(onTap: () async {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                },
                  child: Container(
                    decoration: const BoxDecoration(color:button_color,borderRadius: BorderRadius.all(Radius.circular(40))),
                    height:height*0.06 ,
                    width:width,
                    child:  Center(child:
                    const Text('Signin',style:TextStyle(color:Colors.white))

                    ),
                  ),
                ),

                SizedBox(height: height*0.02,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SelectRole(),));
                    },
                      child: Container(height:height*0.07,

                          child: Text('Signup',style:TextStyle(color:button_color,fontWeight: FontWeight.bold))),
                    ),

                  ],),

          ],
        ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    color: container_color,
height: height*0.2,
                  ),
                ),
              ],
            ),
      ),


      );
  }
}
