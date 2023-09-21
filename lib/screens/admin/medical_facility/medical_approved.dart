import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/utils.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_facility.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_facility_details.dart';


class MedicalApproved extends StatelessWidget {
  String tableName;
  MedicalApproved({super.key,required this.tableName});

  Future<List<MedicalFacility>> getMedicalApproved()async{
List<MedicalFacility> MedicalApproved= await getMedicalFacilityByApproveOrDeny(tableName,'approved');
return MedicalApproved;
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
            FutureBuilder<List<MedicalFacility>>(
              future: getMedicalApproved(), // Call your asynchronous function here
              builder: (BuildContext context, AsyncSnapshot<List<MedicalFacility>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // Show a loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData || snapshot.data!.isNotEmpty) {
                  // Data is available, populate the DataTable with it
                  List<MedicalFacility>? medicalFacilitys = snapshot.data;
                  return
                    medicalFacilitys!.length==0?
                    Center(child: Text('No Medical Approved found.'),)
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
                    rows: medicalFacilitys!
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
                              PopupMenuButton(itemBuilder: (_) {
                                return <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'Update',
                                    child: Text('Update'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Details',
                                    child: Text('Details'),
                                  ),
                                ];
                              },
                                  onSelected: (String value) {
                                    switch (value) {
                                      case 'Update':
// Handle Option 1
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
                            // Handle row selection, e.g., navigate to details screen
                            // You can implement this based on your needs.
                          }
                        },
                      ),
                    )
                        .toList(),
                  );
                  
                  
                } else {
                  return Text('No Medical Approved found.');

                }
              },
            )

          ),
        );
    }

}
