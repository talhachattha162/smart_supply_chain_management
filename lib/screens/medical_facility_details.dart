import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/firebase_user.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_item.dart';
import 'package:smart_supply_chain_management_fyp/firebase/storeMedicalRequesteditems.dart';
import 'package:smart_supply_chain_management_fyp/models/requestedMedicalItem.dart';
import 'package:smart_supply_chain_management_fyp/providers/medicalFacility.dart';
import 'package:smart_supply_chain_management_fyp/utils/theme.dart';

import '../models/medical_facility.dart';
import '../models/user.dart';
import '../providers/medicalItems.dart';
import '../providers/user.dart';
import 'medical_manager/medical_stock.dart';

class MedicalFacilityDetails extends StatefulWidget {
  final MedicalFacility? medicalFacility;
final bool appbar;
  const MedicalFacilityDetails({super.key,required this.medicalFacility,required this.appbar});

  @override
  State<MedicalFacilityDetails> createState() => _MedicalFacilityDetailsState();
}

class _MedicalFacilityDetailsState extends State<MedicalFacilityDetails> {

  bool isLoadingForRequest=false;
  List<int> quantities=[];

 Future<UserModel?> getManager() async {
UserService userService=UserService();
UserModel? userModel=await userService.getUserById(widget.medicalFacility!.managerId);
return userModel;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(),      resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: getManager(),
              builder: (context, snapshot) {
                UserModel? user= snapshot.data;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(
                                widget.medicalFacility!.selectedFacilityType =='hospital'
                                    ?
                                'lib/assets/imgs/hospital.png'
                                    :
                                widget.medicalFacility!.selectedFacilityType=='clinic'
                                    ?
                                'lib/assets/imgs/clinic.png'
                                    :
                                'lib/assets/imgs/pharmacy.png'

                              ,fit: BoxFit.fill,),
                            ),
                            radius: 50,
                          ),

                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.medicalFacility!.facilityName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Text(
                                    widget.medicalFacility!.selectedFacilityType
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.timelapse),
                                  Text('Opening Hours 24/7'),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  Text(widget.medicalFacility!.location.length <= 30
                                      ? widget.medicalFacility!.location
                                      : widget.medicalFacility!.location.substring(0, 30)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                            child: Container(
                                width: width * 0.47,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: button_color,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.email,color: Colors.white),
                                        SizedBox(width: width*0.02,),

                                        Text(
                                          'Email',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    )))),
                        InkWell(
                            child: Container(
                                width: width * 0.44,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: button_color,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                        Icon(Icons.phone,color: Colors.white,),
                                        SizedBox(width: width*0.02,),
                                        Text(
                                         'Phone',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    )))),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Image.asset('lib/assets/imgs/double-bed.png',
                                width: 35, height: 35, fit: BoxFit.fill),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            Text(
                              widget.medicalFacility!.numberOfBeds.toString(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset('lib/assets/imgs/staff.png',
                                width: 35, height: 35, fit: BoxFit.fill),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            Text(
                              widget.medicalFacility!.medicalStaff.toString(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset('lib/assets/imgs/medical-equipment.png',
                                width: 35, height: 35, fit: BoxFit.fill),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            Text(
                              widget.medicalFacility!.availableMedicalEquipmentCount
                                  .toString(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ],
                    ),

                    SizedBox(
                      height: height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.access_time, size: 24),
                            Text(
                              'Opening Time:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.medicalFacility!.selectedStartTime!.hour
                                  .toString() + ':'+ widget.medicalFacility!
                                  .selectedStartTime!.minute.toString(),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.access_time, size: 24),
                            Text(
                              'Closing Time:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.medicalFacility!.selectedEndTime!.hour.toString() + ':'+
                                  widget.medicalFacility!.selectedEndTime!.minute
                                      .toString(),

                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(
                      height: height * 0.04,
                    ),
                    DefaultTabController(
                      length: 3, // Set the number of tabs
                      initialIndex: 0, // Set the initial tab index
                      child:
                      Column(
                        children: [
                          TabBar(
                            tabs: [
                              Tab(text: 'About'),
                              Tab(text: 'Accessibility'),
                              Tab(text: 'Manager'),
                            ], // Pass the list of tabs
                          ),
                          SizedBox(
                            height: height * 0.3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0),
                              child: TabBarView(
                                children: [
                                  Text(widget.medicalFacility!.inventoryDesc),
                                  Text(widget.medicalFacility!.accessibility),
                                 snapshot.connectionState==ConnectionState.waiting?
                                   Center(child: CircularProgressIndicator()):
                                   Container(
                                     padding: EdgeInsets.only(
                                         bottom: height * 0.015,
                                         left: 20,
                                         right: 20),
                                     child: Card(
                                       elevation: 5.0, // Add shadow
                                       child: Padding(
                                         padding: EdgeInsets.all(16.0),
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment
                                               .start,
                                           children: <Widget>[
                                             Text(
                                               user!.name,
                                               style: TextStyle(
                                                 fontSize: 24.0,
                                                 fontWeight: FontWeight.bold,
                                               ),
                                             ),
                                             SizedBox(height: 8.0),
                                             Text(
                                               'Email: ${user.email}',
                                               style: TextStyle(
                                                 fontSize: 16.0,
                                               ),
                                             ),
                                             SizedBox(height: 8.0),
                                             Text(
                                               'Phone: ${user.phoneno}',
                                               style: TextStyle(
                                                 fontSize: 16.0,
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                     ),
                                   )

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );

              }
            ),
          ),
        ),

      floatingActionButton:FloatingActionButton(onPressed: () async {
        MedicalFacilityProvider.medicalFacility=widget.medicalFacility;
       await Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalStock(),));
        // MedicalFacilityProvider.medicalFacility=null;
       if(MedicalItemProvider.medicalItems.length!=0) {
         for (int i = 0; i < MedicalItemProvider.medicalItems.length; i++) {
           quantities.add(1);
         }
         showDialog(context: context, builder: (context) {
           return
             StatefulBuilder(
                 builder: (context, setState) {
                   return AlertDialog(
                     title: Text('Items'),
                     content: Container(
                       width: double.maxFinite,
                       child:
                       MedicalItemProvider.medicalItems == null ?
                       Center(child: Text('Nothing found'))
                           :
                       MedicalItemProvider.medicalItems!.isEmpty
                           ?
                       Center(child: Text('Nothing found'))
                           :
                       ListView.builder(
                         shrinkWrap: true,
                         itemCount: MedicalItemProvider.medicalItems!.length,
                         itemBuilder: (context, index) {
                           return Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment
                                   .spaceBetween,
                               children: [
                                 Text(MedicalItemProvider.medicalItems![index]
                                     .itemName
                                     .toString()),
                                 Row(
                                   children: [
                                     IconButton(
                                       icon: Icon(Icons.remove),
                                       onPressed: () {
                                         if (quantities[index] > 1) {
                                           setState(() {
                                             quantities[index] =
                                                 quantities[index] - 1;
                                           });
                                         }
                                       },
                                     ),
                                     Text(quantities[index].toString()),
                                     IconButton(
                                       icon: Icon(Icons.add),
                                       onPressed: () {
                                         if (quantities[index] <
                                             MedicalItemProvider
                                                 .medicalItems![index]
                                                 .quantityInStock!) {
                                           setState(() {
                                             quantities[index] =
                                                 quantities[index] + 1;
                                           });
                                         }
                                       },
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           );
                         },
                       ),
                     ),
                     actions: [
                       TextButton(
                         onPressed: () async {
                           setState(() {
                             isLoadingForRequest = true;
                           });
                           MedicalItemService medicalItemService = MedicalItemService();
                           for (int i = 0; i <
                               MedicalItemProvider.medicalItems.length; i++) {
                             await medicalItemService.updateMedicalItem(
                                 MedicalItemProvider.medicalItems[i].id,
                                 MedicalItemProvider.medicalItems[i]
                                     .quantityInStock! - quantities[i]);
                             MedicalItemProvider.medicalItems[i]
                                 .quantityInStock = quantities[i];
                           }
                           quantities.clear();
                           RequestedMedicalItemService requestMedicalItemService = RequestedMedicalItemService();
                           RequestedMedicalItem requestedMedicalItem = RequestedMedicalItem(
                               id: '',
                               medicalItems: MedicalItemProvider.medicalItems,
                               resident: UserProvider.userModel,
                           status: 'pending',
                             remarks: '',
                             Recievedby: ''
                           );
                           await requestMedicalItemService
                               .createRequestedMedicalItem(
                               requestedMedicalItem);
                           MedicalItemProvider.medicalItems.clear();
                           setState(() {
                             isLoadingForRequest = false;
                           });
                           Navigator.pop(context);
                         },
                         child: isLoadingForRequest ? Center(
                             child: CircularProgressIndicator()) : Text(
                             'Request'),
                       ),
                       TextButton(
                         onPressed: () {
                           MedicalItemProvider.medicalItems.clear();
                           Navigator.pop(context);
                         },
                         child: Text('Close'),
                       ),
                     ],
                   );
                 }
             );
         }
         );
       }
      } ,child: Text('Stock'))

    );
  }
}
