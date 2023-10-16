import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';
import '../../providers/medicalItems.dart';
import '../../providers/user.dart';
import '../../utils/theme.dart';
import '../medical_facility_details.dart';

class MedicalStockDetail extends StatefulWidget {
  final MedicalItem medicalItem;
   MedicalStockDetail({super.key, required this.medicalItem});

  @override
  State<MedicalStockDetail> createState() => _MedicalStockDetailState();
}

class _MedicalStockDetailState extends State<MedicalStockDetail> {
 bool isRequested=false;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted){
      setState(() {
        isRequested=  MedicalItemProvider.medicalItems!.contains(widget.medicalItem);
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
                          'lib/assets/imgs/medicine1.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          widget.medicalItem.itemName.toString(),
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          widget.medicalItem.brand.toString(),
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
                                '${widget.medicalItem.expirationDate!.day}-${widget.medicalItem.expirationDate!.month}-${widget.medicalItem.expirationDate!.year}'),
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
                      Text(widget.medicalItem.unitOfMeasurement.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Quantity',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.medicalItem.quantityInStock.toString()),
                    ],
                  ),
                  widget.medicalItem.reorderLevel == 0
                      ? Container()
                      : Column(
                          children: [
                            Text('Reorder Level',style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.medicalItem.reorderLevel.toString()),
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
                      Text(widget.medicalItem.stockStatus.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Expiry',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.medicalItem
                          .expirationDate!
                          .day
                          .toString() +
                          '-' +
                          widget.medicalItem
                              .expirationDate!
                              .month
                              .toString() +
                          '-' +
                          widget.medicalItem
                              .expirationDate!
                              .year
                              .toString()),
                    ],
                  ),
                  widget.medicalItem.shelfLocation == ''
                      ? Container()
                      :
                  Column(
                    children: [
                      Text('Shelf',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.medicalItem.shelfLocation.toString()),
                    ],
                  ),
                ],
              ),


              SizedBox(
                height: height * 0.02,
              ),


              widget.medicalItem.suppliername == ''
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
                  DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Name',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Phone',
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(widget.medicalItem.suppliername.toString(),overflow: TextOverflow.ellipsis,)),
                          DataCell(Text('Email',style: TextStyle(color: container_color)),),
                          DataCell(Text('Phone',style: TextStyle(color: container_color)),),
                        ],
                      ),
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
                  Text(widget.medicalItem.description.toString(),maxLines: 20),
                ],
              ),

              SizedBox(height: height*0.02,),
              widget.medicalItem.additionalNotes == ''
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
                  Text(widget.medicalItem.additionalNotes.toString(),maxLines: 20),
                ],
              ),
              UserProvider.userModel!.userRole == 'Resident'
                  ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.medicalItem.quantityInStock!<=0 || widget.medicalItem.stockStatus=='Awaiting Delivery' || widget.medicalItem.stockStatus=='Out of Stock'?


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
                      MedicalItemProvider.medicalItems.add(widget.medicalItem);
                      isRequested=  MedicalItemProvider.medicalItems.contains(widget.medicalItem);
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
