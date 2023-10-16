import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/firebase_user.dart';
import 'package:smart_supply_chain_management_fyp/firebase/storeMedicalRequesteditems.dart';

import '../../models/requestedMedicalItem.dart';
import '../../models/user.dart';

class MedicalRequestedItemsDetail extends StatefulWidget {
  final RequestedMedicalItem requestedMedicalItem;
   MedicalRequestedItemsDetail({super.key,required this.requestedMedicalItem});

  @override
  State<MedicalRequestedItemsDetail> createState() => _MedicalRequestedItemsDetailState();
}

class _MedicalRequestedItemsDetailState extends State<MedicalRequestedItemsDetail> {

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
                itemCount:widget.requestedMedicalItem.medicalItems.length ,
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
                      CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            'lib/assets/imgs/medicine1.png'
                            ,fit: BoxFit.fill,),
                        ),
                        radius: 50,
                      ),

                      Column(
                        children: [
                          Text(
                            widget.requestedMedicalItem.medicalItems[index]!.itemName.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          Text(
                            widget.requestedMedicalItem.medicalItems[index]!.brand.toString(),
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
                                    widget.requestedMedicalItem.medicalItems[index]!.quantityInStock.toString(),
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
                                    widget.requestedMedicalItem.medicalItems[index]!.unitOfMeasurement.toString(),

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

          widget.requestedMedicalItem.status=='approved'
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
                          widget.requestedMedicalItem.assignedReliefWorker!.name,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Email: ${widget.requestedMedicalItem.assignedReliefWorker!.email}',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Phone: ${widget.requestedMedicalItem.assignedReliefWorker!.phoneno}',
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
          widget.requestedMedicalItem.status=='pending'
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
                  RequestedMedicalItemService requestedMedicalItemService=RequestedMedicalItemService();
                  await requestedMedicalItemService.updateRequestedMedicalItemAssignedReliefWorker(widget.requestedMedicalItem.id, selectedReliefWorker!);
                  Navigator.pop(context,1);
                }
                setState(() {
                  isAssignLoading=false;
                });
                }, child:isAssignLoading?CircularProgressIndicator(): Text('Assign'))
            ],
          )
              :
          widget.requestedMedicalItem.remarks==''?
          Center(child: Text('Remarks not added '+widget.requestedMedicalItem.remarks.toString()),)
              :
              Center(child: Text('Remarks: '+widget.requestedMedicalItem.remarks.toString()),)
        ]),
      ),
    );
  }
}
