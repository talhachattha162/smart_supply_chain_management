import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/models/relief_camp.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_details.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_manager/addUpdateReliefCampInfo.dart';

import '../../firebase/firebase_auth.dart';
import '../../firebase/relief_camp.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../providers/user.dart';

class ReliefCampManagerMain extends StatefulWidget {
  const ReliefCampManagerMain({super.key});

  @override
  State<ReliefCampManagerMain> createState() => _ReliefCampManagerMainState();
}

class _ReliefCampManagerMainState extends State<ReliefCampManagerMain> {




  ReliefCamp? reliefCamp;
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkReliefCamp();
  }

  checkReliefCamp() async {
    reliefCamp=await getReliefCamp();
    isLoading=false;
    setState(() {

    });
  }
  Future<ReliefCamp?> getReliefCamp() async {

    ReliefCampService reliefCampService=ReliefCampService();
    ReliefCamp? reliefCamp= await  reliefCampService.getReliefCampByManagerId(UserProvider.userModel!.id);

    return reliefCamp;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

      isLoading?
      Center(child: CircularProgressIndicator())
          :
      reliefCamp==null
          ?
      ReliefCampForm()
          :
      reliefCamp!.approveOrDeny=='approved'
          ?
      ReliefCampDetails(reliefCamp: reliefCamp,appbar: false,)
          :
      reliefCamp!.approveOrDeny=='pending'
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
