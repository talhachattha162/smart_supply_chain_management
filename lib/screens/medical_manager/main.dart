import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_facility.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_facility.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_manager/addUpdateMedicalInfo.dart';
import '../../firebase/firebase_auth.dart';
import '../../main.dart';
import '../../providers/user.dart';
import '../medical_facility_details.dart';


class MedicalManagerMain extends StatefulWidget {
  const MedicalManagerMain({super.key});

  @override
  State<MedicalManagerMain> createState() => _MedicalManagerMainState();
}

class _MedicalManagerMainState extends State<MedicalManagerMain> {

  MedicalFacility? medicalFacility;
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkMedicalFacility();
  }

  checkMedicalFacility() async {
    medicalFacility=await getMedicalFacility();
    isLoading=false;
    setState(() {

    });
  }
  Future<MedicalFacility?> getMedicalFacility() async {

    MedicalFacilityService medicalFacilityService=MedicalFacilityService();
  MedicalFacility? medicalFacility= await  medicalFacilityService.getMedicalFacilityByManagerId(UserProvider.userModel!.id);

  return medicalFacility;
  }
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
          isLoading?
              Center(child: CircularProgressIndicator())
              :
          medicalFacility==null
              ?
              MedicalFacilityForm()
              :
          medicalFacility!.approveOrDeny=='approved'
              ?
      MedicalFacilityDetails(medicalFacility:medicalFacility,appbar: false,):
          medicalFacility!.approveOrDeny=='pending'
              ?
              Center(child: Text('Approval Pending'))
              :
          Center(child: Text('Approval Denied'))
,
        appBar: AppBar(),
        drawer: Drawer(backgroundColor: Colors.blueAccent,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(UserProvider.userModel!.name),
                accountEmail: Text(UserProvider.userModel!.email),
                currentAccountPicture: ClipOval(
                  child:  CachedNetworkImage(
                    imageUrl: UserProvider.userModel!.photoUrl,

                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),

                ),
                onDetailsPressed: () {

                },
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  // Handle navigation to the home page
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Handle navigation to the settings page
                },
              ),ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  AuthService auth=AuthService();
                  await  auth.logoutUser();
                  UserProvider.userModel=null;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyApp(),
                    ),
                  );
                },
              ),
              // Add more ListTile widgets for other menu items
            ],
          ),
        ),
    );
  }
}
