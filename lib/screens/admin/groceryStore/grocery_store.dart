import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/providers/get_grocery.dart';

import 'grocery_approved.dart';
import 'grocery_denied.dart';
import 'grocery_pending.dart';


class AdminGroceryStore extends StatelessWidget {
  const AdminGroceryStore({super.key});


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return  DefaultTabController(
      length: 3, // Set the number of tabs
      initialIndex: 0, // Set the initial tab index
      child:  Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Denied'),
            ], // Pass the list of tabs
          ),
        ),
        body: TabBarView(
          children: [
        GroceryPending(tableName:'grocery_stores'),
            GroceryApproved(tableName:'grocery_stores'),
            GroceryDenied(tableName:'grocery_stores'),
          ],
        ),
      )
    );
  }
}
