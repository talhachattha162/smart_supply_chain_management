import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/providers/signup.dart';
import 'package:smart_supply_chain_management_fyp/screens/select_manager.dart';
import 'package:smart_supply_chain_management_fyp/screens/signup_screen.dart';

import '../clippers/select_role_clipper.dart';
import '../providers/selectrole.dart';

class SelectRole extends StatelessWidget {
  const SelectRole({super.key});

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
          children: [

            InkWell(
              onTap: () {
                Provider.of<SignupRoleProvider>(context,listen: false).selectedRole='Resident';
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(child: Image.asset('lib/assets/imgs/victim.png',width: width*0.125,),radius: 30),
                  Text('Resident'),
                  Container( padding:EdgeInsets.all(8),decoration: BoxDecoration(color:Colors.blue[50],borderRadius: BorderRadius.circular(30)),child: Icon(Icons.arrow_forward_ios))
                ],
              ),
            ),
            SizedBox(height: height*0.08,),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectManagerRole(),));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(child: Image.asset('lib/assets/imgs/manager.png',width: width*0.125,),radius: 30),
                  Text('Manager'),
                  Container( padding:EdgeInsets.all(8),decoration: BoxDecoration(color:Colors.blue[50],borderRadius: BorderRadius.circular(30)),child: Icon(Icons.arrow_forward_ios))
                ],
              ),
            ),
            SizedBox(height: height*0.08,),
            InkWell(
              onTap: () {
                Provider.of<SignupRoleProvider>(context,listen: false).selectedRole='Relief Worker';
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(child: Image.asset('lib/assets/imgs/worker.png',width: width*0.125,),radius: 30),
                  Text('Relief Worker'),
                  Container( padding:EdgeInsets.all(8),decoration: BoxDecoration(color:Colors.blue[50],borderRadius: BorderRadius.circular(30)),child: Icon(Icons.arrow_forward_ios))
                ],
              ),
            ),

          ],
    ),
          ClipPath(
            clipper: WavyBottomClipper(),
            child: Container(
              color: Colors.blue,
              height: height*0.1,
            ),
          ),
        ],
      ),
    ) ;
  }
}