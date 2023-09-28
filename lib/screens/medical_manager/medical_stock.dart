import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_item.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_manager/medical_stock_item_detail.dart';

import '../../providers/medicalFacility.dart';
import '../../providers/user.dart';
import 'add_medical_stock.dart';

class MedicalStock extends StatefulWidget {
  const MedicalStock({super.key});

  @override
  State<MedicalStock> createState() => _MedicalStockState();
}

class _MedicalStockState extends State<MedicalStock> {
  List<MedicalItem> medicalItems = [];
  List<MedicalItem> filteredMedicalItems = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMedicalItems();
  }

  getMedicalItems() async {
    MedicalItemService medicalItemService = MedicalItemService();

    medicalItems = await medicalItemService.getMedicalItemsForHospital(
        MedicalFacilityProvider.medicalFacility!.id);
    filteredMedicalItems = List.from(medicalItems);
    isLoading = false;
    setState(() {});
  }

  void filterItems(String query) {
    if (query.isEmpty || query == null) {
      filteredMedicalItems = List.from(medicalItems);
    } else {
      filteredMedicalItems = medicalItems
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
            : medicalItems.isEmpty
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
                            itemCount: filteredMedicalItems.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalStockDetail(medicalItem: medicalItems[index]),));
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
                                            'lib/assets/imgs/medicine1.png',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            filteredMedicalItems[index]!
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
                                            filteredMedicalItems[index]!
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
                                              Text(filteredMedicalItems[index]!
                                                      .expirationDate!
                                                      .day
                                                      .toString() +
                                                  '-' +
                                                  filteredMedicalItems[index]!
                                                      .expirationDate!
                                                      .month
                                                      .toString() +
                                                  '-' +
                                                  filteredMedicalItems[index]!
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
            UserProvider.userModel!.userRole == 'Medical Facility Manager'
                ? FloatingActionButton(
                    onPressed: () async {
                   await   Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMedicalStock(),
                          ));
                   getMedicalItems();
                    },
                    child: Icon(Icons.add))
                : null
    );
  }
}
