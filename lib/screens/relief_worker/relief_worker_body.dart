import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/relief_Worker.dart';
import 'package:smart_supply_chain_management_fyp/providers/user.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_worker/camp_deliveries.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_worker/grocery_deliveries.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_worker/medical_deliveries.dart';

import '../../utils/theme.dart';

class ReliefWorkerBody extends StatelessWidget {
  const ReliefWorkerBody({super.key});


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Column(children: [

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalDeliveries(),));
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => GroceryDeliveries(),));
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReliefCampDeliveries(),));
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
                    Image.asset('lib/assets/imgs/camp-pic.jpg', fit: BoxFit.fill, height: height*0.15,
                    ),
                    SizedBox(height: height*0.01,),
                    Text('Relief Camp',
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              )),
        ],
      ),

    ],);
  }
}
