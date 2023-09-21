import 'package:flutter/material.dart';

import '../../../firebase/utils.dart';
import '../../../models/grocery_store.dart';
import '../../grocery_store_details.dart';

class GroceryDenied extends StatelessWidget {
  String tableName;

  GroceryDenied({super.key,required this.tableName});

  Future<List<GroceryStore>> getGroceryDenied()async{
    List<GroceryStore> GroceryDenied= await getGroceryStoresByApproveOrDeny(tableName,'denied');
    return GroceryDenied;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SizedBox(
          width: width,
          height: height*0.8,
          child:
          FutureBuilder<List<GroceryStore>>(
            future: getGroceryDenied(), // Call your asynchronous function here
            builder: (BuildContext context, AsyncSnapshot<List<GroceryStore>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData || snapshot.data!.isNotEmpty) {
                // Data is available, populate the DataTable with it
                List<GroceryStore>? groceryStores = snapshot.data;
                return
                  groceryStores!.length==0?
                  Center(child: Text('No Grocery Denied found.'),)
                      : DataTable(
                    dataRowHeight: height*0.09,
                    columnSpacing: 13,
                    horizontalMargin: 5,
                    showCheckboxColumn: false,
                  columns: <DataColumn>[
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Location')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: groceryStores!
                      .map(
                        (groceryStore) => DataRow(
                      cells: [
                        DataCell(Text(groceryStore.storeName.length <= 30
                            ? groceryStore.storeName
                            : groceryStore.storeName.substring(0, 30))
                        ),
                        DataCell(Text(groceryStore.location.length <= 30
                            ? groceryStore.location
                            : groceryStore.location.substring(0, 30))
                        ),
                        DataCell(
                            PopupMenuButton(itemBuilder: (context) {
                              return <PopupMenuEntry<String>>[

                                PopupMenuItem<String>(
                                  value: 'Details',
                                  child: Text('Details'),
                                ),

                              ];
                            },
                                onSelected: (String value) async {
                                  switch (value) {
                                    case 'Details':
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroceryStoreDetails(groceryStore: groceryStore,appbar:true),));
                                      break;
                                  }

                                })
                        )

                      ],
                      onSelectChanged: (selected) {
                        if (selected == true) {
                          // Handle row selection, e.g., navigate to details screen
                          // You can implement this based on your needs.
                        }
                      },
                    ),
                  )
                      .toList(),
                );


              } else {
                return Text('No Grocery Denied found.');

              }
            },
          )

      ),
    );
  }

}
