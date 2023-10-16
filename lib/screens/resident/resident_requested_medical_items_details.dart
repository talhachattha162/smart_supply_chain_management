import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/firebase_user.dart';
import 'package:smart_supply_chain_management_fyp/firebase/storeMedicalRequesteditems.dart';

import '../../models/requestedMedicalItem.dart';
import '../../models/user.dart';

class ResidentRequestedMedicalItemsDetail extends StatefulWidget {
  final RequestedMedicalItem requestedMedicalItem;
  ResidentRequestedMedicalItemsDetail({super.key,required this.requestedMedicalItem});

  @override
  State<ResidentRequestedMedicalItemsDetail> createState() => _ResidentRequestedMedicalItemsDetailState();
}

class _ResidentRequestedMedicalItemsDetailState extends State<ResidentRequestedMedicalItemsDetail> {

  TextEditingController _textEditingController = TextEditingController();

  bool isRemarksButtonLoading=false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
                    padding: const EdgeInsets.all(10.0),
                    margin: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height:height*0.09,
                          child: ClipOval(
                              child:  Image.asset('lib/assets/imgs/medicine.jpg')

                          ),
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
          widget.requestedMedicalItem.status=='approved'
              ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

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
         Center(child: Text('No Relief Worker Assigned'))
              :

          widget.requestedMedicalItem.remarks!=''
              ?
          Center(child: Text('Order Delivered'))
              :
              Column(children: [
                Center(child: Text('Order Delivered')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: _textEditingController,
                      decoration: InputDecoration(border: OutlineInputBorder(),label:  Text('Remarks'))),
                ),
                ElevatedButton(onPressed: () async {
                  if(_textEditingController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter remarks')));
                  }
                  else{
                    setState(() {
                      isRemarksButtonLoading=true;
                    });
                    RequestedMedicalItemService requestedMedicalItemService=RequestedMedicalItemService();
                    await requestedMedicalItemService.updateRequestedMedicalItemRemarks(widget.requestedMedicalItem.id, _textEditingController.text);
                    Navigator.pop(context,1);
                  }
                  setState(() {
                    isRemarksButtonLoading=false;
                  });
                }, child:isRemarksButtonLoading?Center(child: CircularProgressIndicator(),): Text('Submit'))
              ],)
        ]),
      ),
    );
  }
}
