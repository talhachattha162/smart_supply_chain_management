import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/models/relief_camp.dart';
import 'package:smart_supply_chain_management_fyp/providers/relief_Camp.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_details.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_manager/addUpdateReliefCampInfo.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_manager/reliefCamp_requested_items.dart';

import '../../firebase/firebase_auth.dart';
import '../../firebase/relief_camp.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../providers/user.dart';
import '../../utils/theme.dart';
import 'approveOrDenyDonations.dart';

class ReliefCampManagerMain extends StatefulWidget {
  const ReliefCampManagerMain({super.key});

  @override
  State<ReliefCampManagerMain> createState() => _ReliefCampManagerMainState();
}

class _ReliefCampManagerMainState extends State<ReliefCampManagerMain> {




  // ReliefCamp? reliefCamp;
  bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkReliefCamp();
  }

  checkReliefCamp() async {
    ReliefCampProvider.reliefCamp=await getReliefCamp();
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
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(

      body:

      isLoading?
      Center(child: CircularProgressIndicator())
          :
      ReliefCampProvider.reliefCamp==null
          ?
      ReliefCampForm()
          :
      ReliefCampProvider.reliefCamp!.approveOrDeny=='approved'
          ?
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>       ReliefCampDetails(reliefCamp: ReliefCampProvider.reliefCamp,appbar: false,),));
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
                        Image.asset('lib/assets/imgs/camp-pic.jpg',fit: BoxFit.fill,height: height*0.15),
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
                        ReliefCampRequestedItems()
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
                        Text('Item Requests',
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>       ApproveAndDenyDonation(),));
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
                        Image.asset('lib/assets/imgs/camp-pic.jpg',fit: BoxFit.fill,height: height*0.15),
                        SizedBox(height: height*0.01,),
                        Text('Donations',
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
      ReliefCampProvider.reliefCamp!.approveOrDeny=='pending'
          ?
      Center(child: Text('Approval Pending'))
          :
      Center(child: Text('Approval Denied'))
      ,

        appBar: AppBar(          title: Text('Camp Manager')
        ),      resizeToAvoidBottomInset: false,
        drawer: Drawer(backgroundColor: Color(0xFF028A0F),
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
