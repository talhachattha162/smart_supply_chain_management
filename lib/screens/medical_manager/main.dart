import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_facility.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_facility.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_manager/addUpdateMedicalInfo.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_manager/medical_requested_items.dart';
import 'package:smart_supply_chain_management_fyp/screens/showReliefCamps.dart';
import '../../firebase/firebase_auth.dart';
import '../../main.dart';
import '../../providers/medicalFacility.dart';
import '../../providers/user.dart';
import '../../utils/theme.dart';
import '../medical_facility_details.dart';
import '../relief_camp_manager/reliefCamp_requested_items.dart';
import 'medicalManager_requested_relief_camp_items.dart';


class MedicalManagerMain extends StatefulWidget {
  const MedicalManagerMain({super.key});

  @override
  State<MedicalManagerMain> createState() => _MedicalManagerMainState();
}

class _MedicalManagerMainState extends State<MedicalManagerMain> {

  // MedicalFacility? medicalFacility;
  bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkMedicalFacility();
  }

  checkMedicalFacility() async {
    MedicalFacilityProvider.medicalFacility=await getMedicalFacility();
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
          MedicalFacilityProvider.medicalFacility==null
              ?
              MedicalFacilityForm()
              :
          MedicalFacilityProvider.medicalFacility!.approveOrDeny=='approved'
              ?
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>       MedicalFacilityDetails(medicalFacility:MedicalFacilityProvider.medicalFacility,appbar: false,),));
                        },
                        child:
                    Container(
                      width: width * 0.47,
                      height: height * 0.25,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 15,
                              offset: Offset(4, 8), // Shadow position
                            ),
                          ],
                          color: container_color,
                          border: Border.all(color: container_border, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('lib/assets/imgs/medical-facility.jpg',fit: BoxFit.fill,height: height*0.15),
                          SizedBox(height: height*0.01,),
                          Text('Home',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                    )
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              MedicalRequestedItems()
                            ,));
                        },
                        child:
                    Container(
                      width: width * 0.47,
                      height: height * 0.25,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 15,
                              offset: Offset(4, 8), // Shadow position
                            ),
                          ],
                          color: container_color,
                          border: Border.all(color: container_border, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('lib/assets/imgs/request.png',fit: BoxFit.fill,height: height*0.15),
                          SizedBox(height: height*0.01,),
                          Text('Residents Item\n Requests',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                    )
                    ),

                  ]
                    ,),
                  SizedBox(height: height*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>      ShowReliefCamps()));
                        },
                        child:
                    Container(
                      width: width * 0.47,
                      height: height * 0.25,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 15,
                              offset: Offset(4, 8), // Shadow position
                            ),
                          ],
                          color: container_color,
                          border: Border.all(color: container_border, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('lib/assets/imgs/camp.jpg',fit: BoxFit.fill,height: height*0.15),
                          SizedBox(height: height*0.01,),
                          Text('Request From Camp',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                    )
                    ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>      MedicalManagerRequestedReliefCampItems()));
                        },
                        child:
                    Container(
                      width: width * 0.47,
                      height: height * 0.25,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 15,
                              offset: Offset(4, 8), // Shadow position
                            ),
                          ],
                          color: container_color,
                          border: Border.all(color: container_border, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('lib/assets/imgs/camp.jpg',fit: BoxFit.fill,height: height*0.15),
                          SizedBox(height: height*0.01,),
                          Text('Trace Camp Request',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                    )
                    ),
                  ]
                    ,),
                ],
              )
            :
          MedicalFacilityProvider.medicalFacility!.approveOrDeny=='pending'
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
