import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/models/grocery_store.dart';
import 'package:smart_supply_chain_management_fyp/screens/grocery_store_details.dart';
import '../../firebase/firebase_auth.dart';
import '../../firebase/grocery_store.dart';
import '../../main.dart';
import '../../providers/user.dart';
import '../../utils/theme.dart';
import 'addUpdateGroceryInfo.dart';

class GroceryStoreManagerMain extends StatefulWidget {
  const GroceryStoreManagerMain({super.key});

  @override
  State<GroceryStoreManagerMain> createState() => _GroceryStoreManagerMainState();
}

class _GroceryStoreManagerMainState extends State<GroceryStoreManagerMain> {
  GroceryStore? groceryStore;
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkGroceryStore();
  }
  checkGroceryStore() async {
    groceryStore=await getGroceryStore();
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
      groceryStore==null
          ?
      GroceryStoreForm()
          :
      groceryStore!.approveOrDeny=='approved'
          ?
      GroceryStoreDetails(groceryStore: groceryStore,appbar: false,):
      groceryStore!.approveOrDeny=='pending'
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
