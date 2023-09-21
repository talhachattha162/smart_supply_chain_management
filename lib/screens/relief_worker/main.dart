import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase/firebase_auth.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../providers/user.dart';

class ReliefWorkerMain extends StatelessWidget {
  const ReliefWorkerMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Relief Worker')),
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
    );
  }
}
