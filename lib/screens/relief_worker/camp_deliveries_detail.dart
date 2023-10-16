import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_facility.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_item.dart';

import '../../firebase/grocery_item.dart';
import '../../firebase/grocery_store.dart';
import '../../firebase/relief_Worker.dart';
import '../../models/grocery_item.dart';
import '../../models/grocery_store.dart';
import '../../models/medical_facility.dart';
import '../../models/medical_item.dart';
import '../../models/requestedReliefCampItem.dart';
import '../../utils/locationService.dart';
import 'medicalDeliveriesMap.dart';

class ReliefCampDeliveriesDetail extends StatefulWidget {
  final RequestedReliefCampItem requestedReliefCampItems;
  ReliefCampDeliveriesDetail({super.key,required this.requestedReliefCampItems});

  @override
  State<ReliefCampDeliveriesDetail> createState() => _ReliefCampDeliveriesDetailState();
}

class _ReliefCampDeliveriesDetailState extends State<ReliefCampDeliveriesDetail> {
  bool isLoading=false;

  TextEditingController recievedBy=TextEditingController();


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: height*0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount:widget.requestedReliefCampItems.reliefCampItems.length ,
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
                              widget.requestedReliefCampItems.reliefCampItems[index]!.itemName.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),

                            Text(
                              widget.requestedReliefCampItems.reliefCampItems[index]!.brand.toString(),
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
                                      widget.requestedReliefCampItems.reliefCampItems[index]!.quantityInStock.toString(),
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
                                      widget.requestedReliefCampItems.reliefCampItems[index]!.unitOfMeasurement.toString(),

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
          SizedBox(
            height: height*0.2,
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(center: LatLng(widget.requestedReliefCampItems.deliveryLatitude, widget.requestedReliefCampItems.deliveryLongitude)),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(widget.requestedReliefCampItems.deliveryLatitude, widget.requestedReliefCampItems.deliveryLongitude),
                          builder: (ctx) => Container(
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.blue,
                              size: 40.0,
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],

                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryMap(destinationPosition:LatLng(widget.requestedReliefCampItems.deliveryLatitude, widget.requestedReliefCampItems.deliveryLongitude) ),));

                    }, child: Center(child: Text('Click here to see navigation'))),
                  ],
                ),

              ],
            ),
          ),

          if (widget.requestedReliefCampItems.Recievedby!='') Center(child: Text(widget.requestedReliefCampItems.Recievedby.toString()),) else Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: recievedBy,
                    decoration: InputDecoration(
                        label: Text('Recieved by'),
                        border: OutlineInputBorder())),
              ),
              SizedBox(height: height*0.02,),
              ElevatedButton(onPressed: () async {
                isLoading=true;
                setState(() {

                });
                ReliefWorkerService reliefWorkerService=ReliefWorkerService();
               await reliefWorkerService.updateRequestedReliefCampItemRecievedby(widget.requestedReliefCampItems.id, recievedBy.text);
               await reliefWorkerService.updateRequestedReliefCampItemStatus(widget.requestedReliefCampItems.id);
               if(widget.requestedReliefCampItems.resident!.userRole=='Medical Facility Manager')
                 {
                   MedicalFacilityService medicalFacilityService=MedicalFacilityService();
                   MedicalFacility? medicalFacility=  await medicalFacilityService.getMedicalFacilityByManagerId(widget.requestedReliefCampItems.resident!.id);
                   MedicalItemService medicalItemService=MedicalItemService();

                   for(int i=0;i<widget.requestedReliefCampItems.reliefCampItems.length;i++){

                    MedicalItem medicalItem= MedicalItem(id: '', hospitalId: medicalFacility!.id, itemName: widget.requestedReliefCampItems.reliefCampItems[i].itemName, brand: widget.requestedReliefCampItems.reliefCampItems[i].brand, description: widget.requestedReliefCampItems.reliefCampItems[i].description, unitOfMeasurement: widget.requestedReliefCampItems.reliefCampItems[i].unitOfMeasurement, quantityInStock: widget.requestedReliefCampItems.reliefCampItems[i].quantityInStock, reorderLevel: widget.requestedReliefCampItems.reliefCampItems[i].reorderLevel, suppliername: widget.requestedReliefCampItems.reliefCampItems[i].suppliername, supplieremail: widget.requestedReliefCampItems.reliefCampItems[i].supplieremail, supplierphone: widget.requestedReliefCampItems.reliefCampItems[i].supplierphone, shelfLocation: widget.requestedReliefCampItems.reliefCampItems[i].shelfLocation, stockStatus: widget.requestedReliefCampItems.reliefCampItems[i].stockStatus, expirationDate: widget.requestedReliefCampItems.reliefCampItems[i].expirationDate, additionalNotes: widget.requestedReliefCampItems.reliefCampItems[i].additionalNotes);
                     await medicalItemService.addMedicalItem(medicalItem);
                   }
                   }
               else if(widget.requestedReliefCampItems.resident!.userRole=='Grocery Store Manager'){
                 GroceryStoreService groceryStoreService=GroceryStoreService();
                 GroceryStore? groceryStore=  await groceryStoreService.getGroceryStoreByManagerId(widget.requestedReliefCampItems.resident!.id);
                 GroceryItemService groceryItemService=GroceryItemService();

                 for(int i=0;i<widget.requestedReliefCampItems.reliefCampItems.length;i++){

                   GroceryItem groceryItem= GroceryItem(id: '', shopId:  groceryStore!.id, itemName: widget.requestedReliefCampItems.reliefCampItems[i].itemName, brand: widget.requestedReliefCampItems.reliefCampItems[i].brand, description: widget.requestedReliefCampItems.reliefCampItems[i].description, unitOfMeasurement: widget.requestedReliefCampItems.reliefCampItems[i].unitOfMeasurement, quantityInStock: widget.requestedReliefCampItems.reliefCampItems[i].quantityInStock, reorderLevel: widget.requestedReliefCampItems.reliefCampItems[i].reorderLevel, suppliername: widget.requestedReliefCampItems.reliefCampItems[i].suppliername, supplieremail: widget.requestedReliefCampItems.reliefCampItems[i].supplieremail, supplierphone: widget.requestedReliefCampItems.reliefCampItems[i].supplierphone, shelfLocation: widget.requestedReliefCampItems.reliefCampItems[i].shelfLocation, stockStatus: widget.requestedReliefCampItems.reliefCampItems[i].stockStatus, expirationDate: widget.requestedReliefCampItems.reliefCampItems[i].expirationDate, additionalNotes: widget.requestedReliefCampItems.reliefCampItems[i].additionalNotes);
                   await groceryItemService.addGroceryItem(groceryItem);
                 }
               }
               isLoading=false;
                Navigator.pop(context,1);

              }, child: isLoading?Center(child: CircularProgressIndicator()):Text('Submit'))
            ],
          ),
        ]),
      ),
    );
  }
}
