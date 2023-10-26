import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/models/grocery_store.dart';
import 'package:smart_supply_chain_management_fyp/providers/grocerystore.dart';
import 'package:smart_supply_chain_management_fyp/screens/grocery_store_details.dart';
import '../../firebase/firebase_auth.dart';
import '../../firebase/grocery_store.dart';
import '../../main.dart';
import '../../providers/user.dart';
import '../../utils/theme.dart';
import '../showReliefCamps.dart';
import 'addUpdateGroceryInfo.dart';
import 'groceryManager_requested_relief_camp_items.dart';
import 'grocery_requested_items.dart';

class GroceryStoreManagerMain extends StatefulWidget {
  const GroceryStoreManagerMain({super.key});

  @override
  State<GroceryStoreManagerMain> createState() => _GroceryStoreManagerMainState();
}

class _GroceryStoreManagerMainState extends State<GroceryStoreManagerMain> {
  // GroceryStore? groceryStore;
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkGroceryStore();
  }
  checkGroceryStore() async {
    GroceryStoreProvider.groceryStore=await getGroceryStore();
    isLoading=false;
    setState(() {

    });
  }

  Future<GroceryStore?> getGroceryStore() async {

    GroceryStoreService groceryStoreService=GroceryStoreService();
    GroceryStore? groceryStore= await  groceryStoreService.getGroceryStoreByManagerId(UserProvider.userModel!.id);

    return groceryStore;
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
      GroceryStoreProvider.groceryStore==null
          ?
      GroceryStoreForm()
          :
      GroceryStoreProvider.groceryStore!.approveOrDeny=='approved'
          ?

      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>          GroceryStoreDetails(groceryStore: GroceryStoreProvider.groceryStore,appbar: false,)
                    ));
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
                        Image.asset('lib/assets/imgs/grocery-store-1.jpg',fit: BoxFit.fill,height: height*0.15),
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
                        GroceryRequestedItems()
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>      GroceryManagerRequestedReliefCampItems()));
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
      GroceryStoreProvider.groceryStore!.approveOrDeny=='pending'
          ?
      Center(child: Text('Approval Pending'))
          :
      Center(child: Text('Approval Denied'))
        ,

        appBar: AppBar(          title: Text('Store Manager')
        ),
        drawer: Drawer(backgroundColor: Color(0xFF028A0F),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(UserProvider.userModel!.name),
                accountEmail: Text(UserProvider.userModel!.email),
                currentAccountPicture:
                ClipOval(
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
