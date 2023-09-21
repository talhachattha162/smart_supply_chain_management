import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/utils.dart';

import '../../../models/medical_facility.dart';
import '../../medical_facility_details.dart';

class MedicalPending extends StatefulWidget {
  String tableName;
  MedicalPending({super.key,required this.tableName });

  @override
  State<MedicalPending> createState() => _MedicalPendingState();
}

class _MedicalPendingState extends State<MedicalPending> {
  Future<List<MedicalFacility>> getMedicalPending()async{
    List<MedicalFacility> MedicalPending= await getMedicalFacilityByApproveOrDeny(widget.tableName,'pending');
    return MedicalPending;
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
          FutureBuilder<List<MedicalFacility>>(
            future: getMedicalPending(), // Call your asynchronous function here
            builder: (BuildContext context, AsyncSnapshot<List<MedicalFacility>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData || snapshot.data!.isNotEmpty) {
                // Data is available, populate the DataTable with it
                List<MedicalFacility>? MedicalFacilitys = snapshot.data;
                return
                  MedicalFacilitys!.length==0?
                    Center(child: Text('No Medical Pending found.'),)
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
                  rows: MedicalFacilitys!
                      .map(
                        (medicalFacility) => DataRow(
                      cells: [
                        DataCell(Text(medicalFacility.facilityName.length <= 30
                            ? medicalFacility.facilityName
                            : medicalFacility.facilityName.substring(0, 30))
                        ),
                        DataCell(Text(medicalFacility.location.length <= 30
                            ? medicalFacility.location
                            : medicalFacility.location.substring(0, 30))
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
                                      await  updateApproveOrDeny(medicalFacility.id,'approved',widget.tableName);
                                      setState(() {
                                      });
                                      break;
                                    case 'Deny':
                                      await updateApproveOrDeny(medicalFacility.id,'denied',widget.tableName);
                                      setState(() {
                                      });
                                      break;
                                    case 'Details':
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalFacilityDetails(medicalFacility: medicalFacility,appbar: true,),));
                                      break;
                                  }

                                })
                        )

                      ],
                      onSelectChanged: (selected) {
                        if (selected == true) {

                        }
                      },
                    ),
                  )
                      .toList(),
                );


              } else {
                return Text('No Medical Pending found.');

              }
            },
          )

      ),
    );
  }
}



