import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/models/grocery_item.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';
import '../../providers/groceryItems.dart';
import '../../providers/medicalItems.dart';
import '../../providers/user.dart';
import '../../utils/theme.dart';
import '../medical_facility_details.dart';

class GroceryStockDetail extends StatefulWidget {
  final GroceryItem groceryItem;
   GroceryStockDetail({super.key, required this.groceryItem});

  @override
  State<GroceryStockDetail> createState() => _GroceryStockDetailState();
}

class _GroceryStockDetailState extends State<GroceryStockDetail> {
 bool isRequested=false;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted){
      setState(() {
        isRequested=  GroceryStoreItemProvider.groceryStoreItems!.contains(widget.groceryItem);
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
                    Container(
                      height:height*0.09,
                      child: ClipOval(
                          child:  Image.asset('lib/assets/imgs/grocery.jpg')

                      ),
                    ),

                    Column(
                      children: [
                        Text(
                          widget.groceryItem.itemName.toString(),
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          widget.groceryItem.brand.toString(),
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
                                '${widget.groceryItem.expirationDate!.day}-${widget.groceryItem.expirationDate!.month}-${widget.groceryItem.expirationDate!.year}'),
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
                      Text(widget.groceryItem.unitOfMeasurement.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Quantity',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.groceryItem.quantityInStock.toString()),
                    ],
                  ),
                  widget.groceryItem.reorderLevel == 0
                      ? Container()
                      : Column(
                          children: [
                            Text('Reorder Level',style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.groceryItem.reorderLevel.toString()),
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
                      Text(widget.groceryItem.stockStatus.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Expiry',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.groceryItem
                          .expirationDate!
                          .day
                          .toString() +
                          '-' +
                          widget.groceryItem
                              .expirationDate!
                              .month
                              .toString() +
                          '-' +
                          widget.groceryItem
                              .expirationDate!
                              .year
                              .toString()),
                    ],
                  ),
                  widget.groceryItem.shelfLocation == ''
                      ? Container()
                      :
                  Column(
                    children: [
                      Text('Shelf',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.groceryItem.shelfLocation.toString()),
                    ],
                  ),
                ],
              ),


              SizedBox(
                height: height * 0.02,
              ),


              widget.groceryItem.suppliername == ''
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
                          DataCell(Text(widget.groceryItem.suppliername.toString(),overflow: TextOverflow.ellipsis,)),
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
                  Text(widget.groceryItem.description.toString(),maxLines: 20),
                ],
              ),

              SizedBox(height: height*0.02,),
              widget.groceryItem.additionalNotes == ''
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
                  Text(widget.groceryItem.additionalNotes.toString(),maxLines: 20,),
                ],
              ),
              UserProvider.userModel!.userRole == 'Resident'
                  ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.groceryItem.quantityInStock!<=0 || widget.groceryItem.stockStatus=='Awaiting Delivery' || widget.groceryItem.stockStatus=='Out of Stock'?


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
                      GroceryStoreItemProvider.groceryStoreItems.add(widget.groceryItem);
                      isRequested=  GroceryStoreItemProvider.groceryStoreItems.contains(widget.groceryItem);
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
