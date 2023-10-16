import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_supply_chain_management_fyp/firebase/relief_Worker.dart';

import '../../models/requestedMedicalItem.dart';
import 'medicalDeliveriesMap.dart';

class MedicalDeliveriesDetail extends StatefulWidget {
  final RequestedMedicalItem requestedMedicalItems;
   MedicalDeliveriesDetail({super.key,required this.requestedMedicalItems});

  @override
  State<MedicalDeliveriesDetail> createState() => _MedicalDeliveriesDetailState();
}

class _MedicalDeliveriesDetailState extends State<MedicalDeliveriesDetail> {
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
                itemCount:widget.requestedMedicalItems.medicalItems.length ,
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
                              widget.requestedMedicalItems.medicalItems[index]!.itemName.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),

                            Text(
                              widget.requestedMedicalItems.medicalItems[index]!.brand.toString(),
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
                                      widget.requestedMedicalItems.medicalItems[index]!.quantityInStock.toString(),
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
                                      widget.requestedMedicalItems.medicalItems[index]!.unitOfMeasurement.toString(),

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
                  options: MapOptions(center: LatLng(widget.requestedMedicalItems.deliveryLatitude, widget.requestedMedicalItems.deliveryLongitude)),
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
                          point: LatLng(widget.requestedMedicalItems.deliveryLatitude, widget.requestedMedicalItems.deliveryLongitude),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryMap(destinationPosition:LatLng(widget.requestedMedicalItems.deliveryLatitude, widget.requestedMedicalItems.deliveryLongitude) ),));

                    }, child: Center(child: Text('Click here to see navigation'))),
                  ],
                ),

              ],
            ),
          ),

          widget.requestedMedicalItems.Recievedby!=''?
          Center(child: Text(widget.requestedMedicalItems.Recievedby.toString()),)
              :
          Column(
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
                await  reliefWorkerService.updateRequestedMedicalItemRecievedby(widget.requestedMedicalItems.id, recievedBy.text);
                await  reliefWorkerService.updateRequestedMedicalItemStatus(widget.requestedMedicalItems.id);
                isLoading=false;
                Navigator.pop(context,1);

              }, child:isLoading?Center(child: CircularProgressIndicator()): Text('Submit'))
            ],
          )

        ]),
      ),
    );
  }
}
