import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/firebase_user.dart';
import 'package:smart_supply_chain_management_fyp/firebase/storeMedicalRequesteditems.dart';

import '../../firebase/storeGroceryRequesteditems.dart';
import '../../models/requestedGroceryItem.dart';
import '../../models/requestedMedicalItem.dart';
import '../../models/user.dart';

class GroceryRequestedItemsDetail extends StatefulWidget {
  final RequestedGroceryItem requestedGroceryItem;
   GroceryRequestedItemsDetail({super.key,required this.requestedGroceryItem});

  @override
  State<GroceryRequestedItemsDetail> createState() => _GroceryRequestedItemsDetailState();
}

class _GroceryRequestedItemsDetailState extends State<GroceryRequestedItemsDetail> {

  List<UserModel> reliefWorkers=[];
  UserModel? selectedReliefWorker;
  bool isLoading=true;
  bool isAssignLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReliefWorkers();
  }

  getReliefWorkers() async {
    UserService userService=UserService();
    reliefWorkers=await  userService.getUsersByRole('Relief Worker');
    isLoading=false;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: height*0.55,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount:widget.requestedGroceryItem.groceryItems.length ,
                itemBuilder: (context, index) {
                return         Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height:height*0.09,
                        child: ClipOval(
                            child:  Image.asset('lib/assets/imgs/grocery.jpg')

                        ),
                      ),




                      Column(
                        children: [
                          Text(
                            widget.requestedGroceryItem.groceryItems[index]!.itemName.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          Text(
                            widget.requestedGroceryItem.groceryItems[index]!.brand.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(

                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Qty',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Text(
                                    widget.requestedGroceryItem.groceryItems[index]!.quantityInStock.toString(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Unit',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Text(
                                    widget.requestedGroceryItem.groceryItems[index]!.unitOfMeasurement.toString(),

                                  ),
                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                    ],
                  ),
                );
              },),
            ),
          ),
          isLoading?
              Center(child: CircularProgressIndicator(),)
              :
          reliefWorkers.isEmpty?
              ElevatedButton(onPressed: null, child: Text('No Relief Workers found'))
              :

          widget.requestedGroceryItem.status=='approved'
              ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: null, child: Text('Assigned')),
              Text('Relief Worker Details',style: TextStyle(fontWeight: FontWeight.bold),),
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
                          widget.requestedGroceryItem.assignedReliefWorker!.name,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Email: ${widget.requestedGroceryItem.assignedReliefWorker!.email}',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Phone: ${widget.requestedGroceryItem.assignedReliefWorker!.phoneno}',
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
          )
              :
          widget.requestedGroceryItem.status=='pending'
              ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<UserModel>(
                hint: Text('Select Worker'),
                value: selectedReliefWorker,
                onChanged: (UserModel? newValue) {
                  setState(() {
                    selectedReliefWorker = newValue;
                  });
                },
                items: reliefWorkers.map((UserModel user) {
                  return DropdownMenuItem<UserModel>(
                    value: user,
                    child: Text(user.name), // Adjust this based on your UserModel structure
                  );
                }).toList(),
              ),
              ElevatedButton(onPressed: ()
              async {
                if(selectedReliefWorker==null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select worker')));
                }
                else{
                  setState(() {
                    isAssignLoading=true;
                  });
                  RequestedGroceryItemService requestedGroceryItemService=RequestedGroceryItemService();
                  await requestedGroceryItemService.updateRequestedGroceryItemAssignedReliefWorker(widget.requestedGroceryItem.id, selectedReliefWorker!);
                  Navigator.pop(context,1);
                }
                setState(() {
                  isAssignLoading=false;
                });
                }, child:isAssignLoading?CircularProgressIndicator(): Text('Assign'))
            ],
          )
              :
              Center(child: Text('Remarks: '+widget.requestedGroceryItem.remarks.toString()),)
        ]),
      ),
    );
  }
}
