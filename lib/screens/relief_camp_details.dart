import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/firebase/firebase_user.dart';
import 'package:smart_supply_chain_management_fyp/firebase/reliefCamp_item.dart';
import 'package:smart_supply_chain_management_fyp/firebase/storeReliefCampRequesteditems.dart';
import 'package:smart_supply_chain_management_fyp/models/relief_camp.dart';
import 'package:smart_supply_chain_management_fyp/models/requestedReliefCampItem.dart';
import 'package:smart_supply_chain_management_fyp/providers/relief_Camp.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_manager/relief_camp_stock.dart';
import 'package:smart_supply_chain_management_fyp/utils/theme.dart';
import '../../models/user.dart';
import '../providers/relief_Camp_item.dart';
import '../providers/requestedLocations.dart';
import '../providers/user.dart';
import '../utils/address_picker.dart';
import 'donor/add_donation.dart';

class ReliefCampDetails extends StatelessWidget {
  final ReliefCamp? reliefCamp;
final appbar;
   ReliefCampDetails({super.key,required this.reliefCamp,required this.appbar});
  bool isLoadingForRequest=false;
  List<int> quantities=[];
  
  Future<UserModel?> getManager() async {
    UserService userService=UserService();
    UserModel? userModel=await userService.getUserById(reliefCamp!.managerId);
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
                                  'lib/assets/imgs/relief-camp.png'

                                  ,fit: BoxFit.fill,),
                              ),
                              radius: 50,
                            ),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      reliefCamp!.campName,
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
                                    Text(reliefCamp!.location.length <= 30
                                        ? reliefCamp!.location
                                        : reliefCamp!.location.substring(0, 30)),
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
                                      child: Row(  mainAxisAlignment: MainAxisAlignment.center,
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

                      DefaultTabController(
                        length: 2, // Set the number of tabs
                        initialIndex: 0, // Set the initial tab index
                        child:
                        Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(text: 'About'),
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
                                    Text(reliefCamp!.description),
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
        floatingActionButton:
        UserProvider.userModel!.userRole=='Donor'
            ?
        FloatingActionButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddDonation(),));
            },
            child: Icon(Icons.add))
            :
        FloatingActionButton(onPressed: () async {
          ReliefCampProvider.reliefCamp=reliefCamp;
          await Navigator.push(context, MaterialPageRoute(builder: (context) => ReliefCampStock(),));
          // MedicalFacilityProvider.medicalFacility=null;
          if(ReliefCampItemProvider.reliefCampItems.length!=0) {
            for (int i = 0; i < ReliefCampItemProvider.reliefCampItems.length; i++) {
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

                          ReliefCampItemProvider.reliefCampItems.isEmpty
                              ?
                          Center(child: Text('Nothing found'))
                              :
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: ReliefCampItemProvider.reliefCampItems.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(ReliefCampItemProvider.reliefCampItems[index]
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
                                                ReliefCampItemProvider
                                                    .reliefCampItems[index]
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
                          TextButton(onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPicker(medicalOrGroceryOrCamp: 'request'),));
                          }, child: Container(width:width,child: Center(child: Text('Pick Location')))),

                          TextButton(
                            onPressed: () async {
                              if(Provider.of<RequestedLocationProvider>(context,listen:false).latitude !=0.0 && Provider.of<RequestedLocationProvider>(context,listen:false).latitude!=0.0) {
                                setState(() {
                                isLoadingForRequest = true;
                              });
                              ReliefCampItemService reliefCampItemService = ReliefCampItemService();
                              for (int i = 0; i <
                                  ReliefCampItemProvider.reliefCampItems.length; i++) {
                                await reliefCampItemService.updateReliefCampItem(
                                    ReliefCampItemProvider.reliefCampItems[i].id,
                                    ReliefCampItemProvider.reliefCampItems[i]
                                        .quantityInStock! - quantities[i]);
                                ReliefCampItemProvider.reliefCampItems[i]
                                    .quantityInStock = quantities[i];
                              }
                              quantities.clear();
                              RequestedReliefCampItemService requestReliefCampItemService = RequestedReliefCampItemService();
                              RequestedReliefCampItem requestedReliefCampItem = RequestedReliefCampItem(
                                  id: '',
                                  reliefCampItems:  ReliefCampItemProvider.reliefCampItems,
                                  resident: UserProvider.userModel,
                                  status: 'pending',
                                  remarks: '',
                                Recievedby: '',
                                  deliveryLatitude: Provider
                                      .of<RequestedLocationProvider>(
                                      context, listen: false)
                                      .latitude,
                                  deliveryLongitude: Provider
                                      .of<RequestedLocationProvider>(
                                      context, listen: false)
                                      .longitude

                              );
                              await requestReliefCampItemService
                                  .createRequestedReliefCampItem(
                                  requestedReliefCampItem);
                              ReliefCampItemProvider.reliefCampItems.clear();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request Added')));
                              setState(() {
                                isLoadingForRequest = false;
                              });
                              Provider
                                  .of<RequestedLocationProvider>(context, listen: false)
                                  .latitude = 0.0;
                              Provider
                                  .of<RequestedLocationProvider>(context, listen: false)
                                  .longitude = 0.0;
                              Navigator.pop(context);
                      }
                      else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pick Location to deliver')));
                      }
                            },
                            child: isLoadingForRequest ? Center(
                                child: CircularProgressIndicator()) : Text(
                                'Request'),
                          ),
                          TextButton(
                            onPressed: () {
                              ReliefCampItemProvider.reliefCampItems.clear();
                              Provider.of<RequestedLocationProvider>(context,listen:false).latitude=0.0;
                              Provider.of<RequestedLocationProvider>(context,listen:false).longitude=0.0;
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
