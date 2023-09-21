import 'package:flutter/material.dart';

import '../../../firebase/grocery_store.dart';
import '../../../firebase/utils.dart';
import '../../../models/grocery_store.dart';
import '../../grocery_store_details.dart';

class GroceryPending extends StatefulWidget {
  String tableName;
  GroceryPending({super.key,required this.tableName });

  @override
  State<GroceryPending> createState() => _GroceryPendingState();
}

class _GroceryPendingState extends State<GroceryPending> {
  Future<List<GroceryStore>> getGroceryPending()async{
    List<GroceryStore> GroceryPending= await getGroceryStoresByApproveOrDeny(widget.tableName,'pending');
    return GroceryPending;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SizedBox(
        height: height*0.8,
          width: width,
          child:
          FutureBuilder<List<GroceryStore>>(
            future: getGroceryPending(), // Call your asynchronous function here
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
                    Center(child: Text('No GroceryPending found.'),)
                    :
              DataTable(
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
                                  value: 'Approve',
                                  child: Text('Approve'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Deny',
                                  child: Text('Deny'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Details',
                                  child: Text('Details'),
                                ),
                              ];
                            },
                                onSelected: (String value) async {
                                  switch (value) {
                                    case 'Approve':
                                      await  updateApproveOrDeny(groceryStore.id,'approved',widget.tableName);
                                      break;
                                    case 'Deny':
                                      await updateApproveOrDeny(groceryStore.id,'denied',widget.tableName);
                                      break;
                                    case 'Details':
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroceryStoreDetails(groceryStore: groceryStore,appbar:true),));
                                      break;
                                  }
                                  setState(() {

                                  });
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
                return Text('No GroceryPending found.');

              }
            },
          )

      ),
    );
  }
}



