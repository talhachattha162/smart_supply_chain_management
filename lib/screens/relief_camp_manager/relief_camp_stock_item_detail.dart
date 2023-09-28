import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';
import '../../models/relief_camp_item.dart';
import '../../providers/medicalItems.dart';
import '../../providers/relief_Camp_item.dart';
import '../../providers/user.dart';
import '../../utils/theme.dart';
import '../medical_facility_details.dart';

class ReliefCampStockDetail extends StatefulWidget {
  final ReliefCampItem reliefCampItem;
   ReliefCampStockDetail({super.key, required this.reliefCampItem});

  @override
  State<ReliefCampStockDetail> createState() => _ReliefCampStockDetailState();
}

class _ReliefCampStockDetailState extends State<ReliefCampStockDetail> {
 bool isRequested=false;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted){
      setState(() {
        isRequested=  ReliefCampItemProvider.reliefCampItems!.contains(widget.reliefCampItem);
      });
    }
 }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(),      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1, color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          'lib/assets/imgs/relief-camp.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          widget.reliefCampItem.itemName.toString(),
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          widget.reliefCampItem.brand.toString(),
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          children: [
                            Icon(Icons.timelapse),
                            Text(
                                '${widget.reliefCampItem.expirationDate!.day}-${widget.reliefCampItem.expirationDate!.month}-${widget.reliefCampItem.expirationDate!.year}'),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Unit',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.reliefCampItem.unitOfMeasurement.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Quantity',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.reliefCampItem.quantityInStock.toString()),
                    ],
                  ),
                  widget.reliefCampItem.reorderLevel == 0
                      ? Container()
                      : Column(
                          children: [
                            Text('Reorder Level',style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.reliefCampItem.reorderLevel.toString()),
                          ],
                        ),
                ],
              ),

              SizedBox(
                height: height * 0.02,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Column(
                    children: [
                      Text('Status',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.reliefCampItem.stockStatus.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Expiry',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.reliefCampItem
                          .expirationDate!
                          .day
                          .toString() +
                          '-' +
                          widget.reliefCampItem
                              .expirationDate!
                              .month
                              .toString() +
                          '-' +
                          widget.reliefCampItem
                              .expirationDate!
                              .year
                              .toString()),
                    ],
                  ),
                  widget.reliefCampItem.shelfLocation == ''
                      ? Container()
                      :
                  Column(
                    children: [
                      Text('Shelf',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.reliefCampItem.shelfLocation.toString()),
                    ],
                  ),
                ],
              ),


              SizedBox(
                height: height * 0.02,
              ),


              widget.reliefCampItem.suppliername == ''
                  ?
              Container():
              Column(

                children: [

                  Row(
                    children: [
                      SizedBox(width: width*0.04,),
                      Text('Supplier',style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(widget.reliefCampItem.suppliername.toString()),
                      Text(widget.reliefCampItem.supplieremail.toString()),
                      Text(widget.reliefCampItem.supplierphone.toString()),
                    ],
                  )
                ],
              ),
              SizedBox(height: height*0.02,),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // SizedBox(width: width*0.04,),

                      Text('Description',style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // SizedBox(width: width*0.04,),
                      Text(widget.reliefCampItem.description.toString()),
                    ],
                  ),
                ],
              ),

              SizedBox(height: height*0.02,),
              widget.reliefCampItem.additionalNotes == ''
                  ? Container()
                  : Column(
                children: [
                  SizedBox(height: height*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Additional Notes',style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.reliefCampItem.additionalNotes.toString()),
                    ],
                  ),
                ],
              ),
              UserProvider.userModel!.userRole == 'Resident' ||
                  UserProvider.userModel!.userRole == 'Medical Facility Manager' ||
                  UserProvider.userModel!.userRole == 'Grocery Store Manager'
                  ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.reliefCampItem.quantityInStock!<=0 || widget.reliefCampItem.stockStatus=='Awaiting Delivery' || widget.reliefCampItem.stockStatus=='Out of Stock'?


                  SizedBox(
                      width: width*0.8,
                      child: ElevatedButton(onPressed: null
                          ,
                          child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Out Of stock'),
                          SizedBox(width: width*0.02,),
                          Icon(Icons.error_outline,color: Colors.red,)
                        ],)
                      )

                  )

                      :
                  SizedBox(
                    width: width*0.8,
                    child: ElevatedButton(onPressed: isRequested?null:() {
                      ReliefCampItemProvider.reliefCampItems.add(widget.reliefCampItem);
                      isRequested=  ReliefCampItemProvider.reliefCampItems.contains(widget.reliefCampItem);
                    setState(() {

                    });
                    }, child:
                    isRequested? Text('Added To Cart'): Text('Add To Cart'))
                      
                  )
                ],
              ):
                  Container()
            ],
          ),
        ),
      ),
    );
  }
}
