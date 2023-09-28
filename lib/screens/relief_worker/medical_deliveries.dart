import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_worker/medical_deliveries_detail.dart';

import '../../firebase/relief_Worker.dart';
import '../../models/requestedMedicalItem.dart';
import '../../providers/user.dart';

class MedicalDeliveries extends StatefulWidget {
  const MedicalDeliveries({super.key});

  @override
  State<MedicalDeliveries> createState() => _MedicalDeliveriesState();
}

class _MedicalDeliveriesState extends State<MedicalDeliveries> {
  
  List<RequestedMedicalItem> requestedMedicalItems=[];
  List<RequestedMedicalItem> filteredRequestedMedicalItems=[];
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMedicalRequestsForReliefWorker();
  }

  getMedicalRequestsForReliefWorker() async {
    ReliefWorkerService reliefWorkerService=ReliefWorkerService();
    requestedMedicalItems=await reliefWorkerService.getAllRequestedMedicalItemsForReliefWorker(UserProvider.userModel!.id);
    filteredRequestedMedicalItems=List.from(requestedMedicalItems);
    isLoading=false;
    setState(() {
      
    });
  }

  void filterItems(String query) {
    if (query.isEmpty || query == null) {
      filteredRequestedMedicalItems = List.from(requestedMedicalItems);
    } else {
      filteredRequestedMedicalItems = requestedMedicalItems
          .where((item) =>
      item.id.toLowerCase().contains(query.toLowerCase()) ||
          item.resident!.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body:isLoading
          ? Center(child: CircularProgressIndicator())
          : requestedMedicalItems.isEmpty
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
                itemCount: filteredRequestedMedicalItems.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                  final result=  await  Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalDeliveriesDetail(requestedMedicalItems:  filteredRequestedMedicalItems[index]),));
                  if(result==1){
                    getMedicalRequestsForReliefWorker();
                  }
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
                                child:  Image.asset('lib/assets/imgs/medicine.jpg')

                            ),
                          ),

                          Column(
                            children: [
                              Text(
                                filteredRequestedMedicalItems[index]!
                                    .id
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,

                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Text(
                                filteredRequestedMedicalItems[index]!
                                    .resident!.name
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
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
    );
  }
}
