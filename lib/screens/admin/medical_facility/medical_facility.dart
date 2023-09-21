import 'package:flutter/material.dart';
import 'medical_approved.dart';
import 'medical_denied.dart';
import 'medical_pending.dart';

class AdminMedicalFacility extends StatelessWidget {
  const AdminMedicalFacility({super.key});


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
              MedicalPending(tableName:'medical_facilities'),
              MedicalApproved(tableName:'medical_facilities'),
              MedicalDenied(tableName:'medical_facilities'),
            ],
          ),
        )
    );
  }
}
