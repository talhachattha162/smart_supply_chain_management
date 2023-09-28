import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_item.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_manager/medical_stock_item_detail.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_manager/medical_requested_items_detail.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_manager/reliefCamp_requested_items_detail.dart';

import '../../firebase/storeReliefCampRequesteditems.dart';
import '../../models/requestedMedicalItem.dart';
import '../../models/requestedReliefCampItem.dart';
import '../../providers/medicalFacility.dart';
import '../../providers/user.dart';
import 'add_relief_camp_stock.dart';

class ReliefCampRequestedItems extends StatefulWidget {
  const ReliefCampRequestedItems({super.key});

  @override
  State<ReliefCampRequestedItems> createState() => _ReliefCampRequestedItemsState();
}

class _ReliefCampRequestedItemsState extends State<ReliefCampRequestedItems> {
  List<RequestedReliefCampItem> requestedReliefCampItems = [];
  List<RequestedReliefCampItem> filteredrequestedReliefCampItems = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequestedReliefCampItems();
  }

  getRequestedReliefCampItems() async {
    RequestedReliefCampItemService requestedReliefCampItemService = RequestedReliefCampItemService();
    requestedReliefCampItems = await requestedReliefCampItemService.getAllRequestedReliefCampItems();
    filteredrequestedReliefCampItems = List.from(requestedReliefCampItems);
    isLoading = false;
    setState(() {});
  }

  void filterItems(String query) {
    if (query.isEmpty || query == null) {
      filteredrequestedReliefCampItems = List.from(requestedReliefCampItems);
    } else {
      filteredrequestedReliefCampItems = requestedReliefCampItems
          .where(
              (item) =>
      item.id.toLowerCase().contains(query.toLowerCase())
      )
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : requestedReliefCampItems.isEmpty
            ? Center(
          child: Text('No requests found'),
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  filterItems(
                      value); // Call filterItems when text changes
                },
                decoration: InputDecoration(
                    hintText: 'Search here...',
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              SizedBox(
                height: height * 0.75,
                child: ListView.builder(
                  itemCount: filteredrequestedReliefCampItems.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                      final result=await  Navigator.push(context, MaterialPageRoute(builder: (context) => ReliefCampRequestedItemsDetail(requestedReliefCampItem:filteredrequestedReliefCampItems[index] ),));
                      if(result==1){
                        setState(() {
                          isLoading=true;
                        });
                        getRequestedReliefCampItems();
                      }
                      },
                      child:
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 1, color: Colors.grey)),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height:height*0.09,
                              child: ClipOval(
                                child:  CachedNetworkImage(
                                  imageUrl: filteredrequestedReliefCampItems[index]!
                                      .resident!.photoUrl,

                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),

                              ),
                            ),

                            Column(
                              children: [
                                Text(
                                  filteredrequestedReliefCampItems[index]!
                                      .id
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Text(filteredrequestedReliefCampItems[index]!
                                        .status.toString()),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
    );
  }
}
