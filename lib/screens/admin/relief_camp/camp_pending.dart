import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/grocery_store.dart';
import 'package:smart_supply_chain_management_fyp/firebase/utils.dart';
import 'package:smart_supply_chain_management_fyp/models/relief_camp.dart';

import '../../relief_camp_details.dart';


class ReliefCampPending extends StatefulWidget {
  String tableName;
  ReliefCampPending({super.key,required this.tableName});

  @override
  State<ReliefCampPending> createState() => _ReliefCampPendingState();
}

class _ReliefCampPendingState extends State<ReliefCampPending> {
  Future<List<ReliefCamp>> getReliefCampPending()async{
    List<ReliefCamp> ReliefCampPending= await getReliefCampByApproveOrDeny(widget.tableName,'pending');
    return ReliefCampPending;
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
          FutureBuilder<List<ReliefCamp>>(
            future: getReliefCampPending(), // Call your asynchronous function here
            builder: (BuildContext context, AsyncSnapshot<List<ReliefCamp>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData || snapshot.data!.isNotEmpty) {
                // Data is available, populate the DataTable with it
                List<ReliefCamp>? reliefCamps = snapshot.data;
                return
                  reliefCamps!.length==0?
                  Center(child: Text('No Relief Camp Pending found.'),)
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
                    rows: reliefCamps!
                        .map(
                          (ReliefCamp) => DataRow(
                        cells: [
                          DataCell(Text(ReliefCamp.campName.length <= 30
                              ? ReliefCamp.campName
                              : ReliefCamp.campName.substring(0, 30))
                          ),
                          DataCell(Text(ReliefCamp.location.length <= 30
                              ? ReliefCamp.location
                              : ReliefCamp.location.substring(0, 30))
                          ),
                          DataCell(
                              PopupMenuButton(itemBuilder: (_) {
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
                                        await  updateApproveOrDeny(ReliefCamp.id,'approved',widget.tableName);
                                        setState(() {
                                        });
                                        break;
                                      case 'Deny':
                                        await updateApproveOrDeny(ReliefCamp.id,'denied',widget.tableName);
                                        setState(() {
                                        });
                                        break;
                                      case 'Details':
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReliefCampDetails(reliefCamp: ReliefCamp,appbar: true),));

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
                return Text('No Relief Camp Pending found.');

              }
            },
          )

      ),
    );
  }
}
