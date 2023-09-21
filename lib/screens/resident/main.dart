import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/nearestMedicalFacilities.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/nearestReliefCamps.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/requestSupplies.dart';
import '../../firebase/firebase_auth.dart';
import '../../providers/user.dart';
import '../../utils/theme.dart';
import 'nearestGroceryStores.dart';

class ResidentMain extends StatelessWidget {
  const ResidentMain({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
            children: [
          SizedBox(height: height*0.08,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NearestMedicalFacility(),));
                  },
                  child: Container(
                    width: width * 0.47,
                    height: height * 0.22,
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
                        Text('Medical Facilities',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  )),
              InkWell(
                  onTap: () {
Navigator.push(context, MaterialPageRoute(builder: (context) => NearestGroceryStores(),));
                  },
                  child: Container(
                    width: width * 0.47,
                    height: height * 0.22,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 15,
                            offset: Offset(4, 8), // Shadow position
                          ),
                        ],
                        color: container_color,
                        border: Border.all(color: container_border, width:1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Image.asset('lib/assets/imgs/grocery-store.jpg' ,height: height*0.15,fit: BoxFit.fill),
                        SizedBox(height: height*0.01,),
                        Text('Grocery Stores',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  )),
            ],
          ),
          SizedBox(height: height*0.04,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NearestReliefCamps(),));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(0.0),
                    width: width * 0.5,
                    height: height * 0.22,
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
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Image.asset('lib/assets/imgs/relief-camp.jpg', fit: BoxFit.fill, height: height*0.15,
                        ),
                        SizedBox(height: height*0.01,),
                        Text('Relief Camps',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  )),
            ],
          ),
        ]),
      ),
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