import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_supply_chain_management_fyp/providers/user.dart';
import 'package:smart_supply_chain_management_fyp/screens/admin/grocerystore/grocery_store.dart';
import 'package:smart_supply_chain_management_fyp/screens/admin/relief_camp/relief_camp.dart';
import '../../firebase/firebase_auth.dart';
import '../../main.dart';
import '../../utils/theme.dart';
import 'medical_facility/medical_facility.dart';

class AdminMain extends StatelessWidget {
  const AdminMain({super.key});



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: height*0.03,),
            Container(
              // margin: EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Admin Dashboard',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          BoxShadow(
                            color: Colors.blueAccent,
                            blurRadius: 50,
                          )
                        ],
                      ))
                ],
              ),
            ),
            SizedBox(height: height*0.08,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminMedicalFacility(),));

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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminGroceryStore(),));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminReliefCampFacility(),));
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
          )
      ),
    );
  }
}
