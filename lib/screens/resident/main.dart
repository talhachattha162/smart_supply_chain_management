import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/nearestMedicalFacilities.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/nearestReliefCamps.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/requestSupplies.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/requestedSuppliesMain.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/resident_requested_grocery_items.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/resident_requested_medical_items.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/resident_requested_relief_camp_items.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/viewSuppliesMain.dart';
import '../../firebase/firebase_auth.dart';
import '../../providers/user.dart';
import '../../utils/theme.dart';
import 'crowdsourcing.dart';
import 'nearestGroceryStores.dart';

class ResidentMain extends StatelessWidget {
  const ResidentMain({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SizedBox(height: height*0.05,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSuppliesMain(),));
                      },
                      child: Container(
                        width: width * 0.47,
                        height: height * 0.12,
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
                        child: Center(
                          child: Text('Request Supplies',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                      )),
                ],
              ),
              SizedBox(height: height*0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RequestedSuppliesMain(),));
                      },
                      child: Container(
                        width: width * 0.47,
                        height: height * 0.12,
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
                        child: Center(
                          child: Text('Requested Supplies',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                      )),
                ],
              ),
            ]),
      ),
      appBar: AppBar(
          title: Text('Resident')
      ),
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
            ),
            ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Trends'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Trends(),));
              },
            ),
            ListTile(
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
