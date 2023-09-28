import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_item.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_manager/medical_stock_item_detail.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_manager/relief_camp_stock_item_detail.dart';

import '../../firebase/reliefCamp_item.dart';
import '../../models/relief_camp_item.dart';
import '../../providers/medicalFacility.dart';
import '../../providers/relief_Camp.dart';
import '../../providers/user.dart';
import 'add_relief_camp_stock.dart';

class ReliefCampStock extends StatefulWidget {
  const ReliefCampStock({super.key});

  @override
  State<ReliefCampStock> createState() => _ReliefCampStockState();
}

class _ReliefCampStockState extends State<ReliefCampStock> {
  List<ReliefCampItem> reliefCampItems = [];
  List<ReliefCampItem> filteredReliefCampItems = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReliefCampItems();
  }

  getReliefCampItems() async {
    ReliefCampItemService reliefCampItemService = ReliefCampItemService();
    reliefCampItems = await reliefCampItemService.getReliefCampItemsForCamp(
        ReliefCampProvider.reliefCamp!.id);
    filteredReliefCampItems = List.from(reliefCampItems);
    isLoading = false;
    setState(() {});
  }

  void filterItems(String query) {
    if (query.isEmpty || query == null) {
      filteredReliefCampItems = List.from(reliefCampItems);
    } else {
      filteredReliefCampItems = reliefCampItems
          .where((item) =>
              item.itemName!.toLowerCase().contains(query.toLowerCase()) ||
              item.brand!.toLowerCase().contains(query.toLowerCase()))
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
            : reliefCampItems.isEmpty
                ? Center(
                    child: Text('No Items found'),
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
                            itemCount: filteredReliefCampItems.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReliefCampStockDetail(reliefCampItem: reliefCampItems[index]),));
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
                                            filteredReliefCampItems[index]!
                                                .itemName
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Text(
                                            filteredReliefCampItems[index]!
                                                .brand
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
                                              Icon(Icons.timelapse),
                                              Text(filteredReliefCampItems[index]!
                                                      .expirationDate!
                                                      .day
                                                      .toString() +
                                                  '-' +
                                                  filteredReliefCampItems[index]!
                                                      .expirationDate!
                                                      .month
                                                      .toString() +
                                                  '-' +
                                                  filteredReliefCampItems[index]!
                                                      .expirationDate!
                                                      .year
                                                      .toString()),
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
        floatingActionButton:
            UserProvider.userModel!.userRole == 'Relief Camp Manager'
                ? FloatingActionButton(
                    onPressed: () async {
                   await   Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddReliefCampStock(),
                          ));
                   getReliefCampItems();
                    },
                    child: Icon(Icons.add))
                : null
    );
  }
}
