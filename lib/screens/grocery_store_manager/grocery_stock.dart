import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_item.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_manager/medical_stock_item_detail.dart';

import '../../firebase/grocery_item.dart';
import '../../models/grocery_item.dart';
import '../../providers/grocerystore.dart';
import '../../providers/medicalFacility.dart';
import '../../providers/user.dart';
import 'add_grocery_stock.dart';
import 'grocery_stock_item_detail.dart';

class GroceryStock extends StatefulWidget {
  const GroceryStock({super.key});

  @override
  State<GroceryStock> createState() => _GroceryStockState();
}

class _GroceryStockState extends State<GroceryStock> {
  List<GroceryItem> groceryItems = [];
  List<GroceryItem> filteredGroceryItems = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroceryItems();
  }

  getGroceryItems() async {
    GroceryItemService groceryItemService = GroceryItemService();
    groceryItems = await groceryItemService.getGroceryItemsForShop(
        GroceryStoreProvider.groceryStore!.id);
    filteredGroceryItems = List.from(groceryItems);
    isLoading = false;
    setState(() {});
  }

  void filterItems(String query) {
    if (query.isEmpty || query == null) {
      filteredGroceryItems = List.from(groceryItems);
    } else {
      filteredGroceryItems = groceryItems
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
            : groceryItems.isEmpty
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
                            itemCount: filteredGroceryItems.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => GroceryStockDetail(groceryItem: groceryItems[index]),));
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
                                            child:  Image.asset('lib/assets/imgs/grocery.jpg')

                                        ),
                                      ),

                                      Column(
                                        children: [
                                          Text(
                                            filteredGroceryItems[index]!
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
                                            filteredGroceryItems[index]!
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
                                              Text(filteredGroceryItems[index]!
                                                      .expirationDate!
                                                      .day
                                                      .toString() +
                                                  '-' +
                                                  filteredGroceryItems[index]!
                                                      .expirationDate!
                                                      .month
                                                      .toString() +
                                                  '-' +
                                                  filteredGroceryItems[index]!
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
            UserProvider.userModel!.userRole == 'Grocery Store Manager'
                ? FloatingActionButton(
                    onPressed: () async {
                   await   Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddGroceryStock(),
                          ));
                   getGroceryItems();
                    },
                    child: Icon(Icons.add))
                : null);
  }
}
