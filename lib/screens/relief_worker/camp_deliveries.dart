import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_worker/camp_deliveries_detail.dart';

import '../../firebase/relief_Worker.dart';
import '../../models/requestedReliefCampItem.dart';
import '../../providers/user.dart';

class ReliefCampDeliveries extends StatefulWidget {
  const ReliefCampDeliveries({super.key});

  @override
  State<ReliefCampDeliveries> createState() => _ReliefCampDeliveriesState();
}

class _ReliefCampDeliveriesState extends State<ReliefCampDeliveries> {

  List<RequestedReliefCampItem> requestedReliefCampItems=[];
  List<RequestedReliefCampItem> filteredRequestedReliefCampItems=[];
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReliefCampRequestsForReliefWorker();
  }

  getReliefCampRequestsForReliefWorker() async {
    ReliefWorkerService reliefWorkerService=ReliefWorkerService();
    requestedReliefCampItems=await reliefWorkerService.getAllRequestedReliefCampItemsForReliefWorker(UserProvider.userModel!.id);
    filteredRequestedReliefCampItems=List.from(requestedReliefCampItems);
    isLoading=false;
    setState(() {

    });
  }

  void filterItems(String query) {
    if (query.isEmpty || query == null) {
      filteredRequestedReliefCampItems = List.from(requestedReliefCampItems);
    } else {
      filteredRequestedReliefCampItems = requestedReliefCampItems
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
    return Scaffold(appBar: AppBar(),      resizeToAvoidBottomInset: false,
      body:isLoading
          ? Center(child: CircularProgressIndicator())
          : requestedReliefCampItems.isEmpty
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
                itemCount: filteredRequestedReliefCampItems.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                    final result= await Navigator.push(context, MaterialPageRoute(builder: (context) => ReliefCampDeliveriesDetail(requestedReliefCampItems:filteredRequestedReliefCampItems[index] ),));
                    if(result==1){
                      getReliefCampRequestsForReliefWorker();
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
                                child:  Image.asset('lib/assets/imgs/relief-camp.png')

                            ),
                          ),

                          Column(
                            children: [
                              Text(
                                filteredRequestedReliefCampItems[index]!
                                    .id
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),                                overflow: TextOverflow.ellipsis,

                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Text(
                                filteredRequestedReliefCampItems[index]!
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
