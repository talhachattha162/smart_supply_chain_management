import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/main.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/nearestMedicalFacilities.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/nearestReliefCamps.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/requestSupplies.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/resident_requested_grocery_items.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/resident_requested_medical_items.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/resident_requested_relief_camp_items.dart';
import '../../firebase/firebase_auth.dart';
import '../../providers/user.dart';
import '../../utils/theme.dart';
import 'crowdsourcing.dart';
import 'nearestGroceryStores.dart';

class ViewSuppliesMain extends StatelessWidget {
  const ViewSuppliesMain({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: height*0.05,),
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
                            Image.asset('lib/assets/imgs/grocery-store-1.jpg' ,height: height*0.15,fit: BoxFit.fill),
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
              SizedBox(height: height*0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NearestReliefCamps(),));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
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

    );
  }
}
