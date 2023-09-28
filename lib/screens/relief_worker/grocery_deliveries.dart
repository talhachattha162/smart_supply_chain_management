import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_worker/grocery_delivery_details.dart';

import '../../firebase/relief_Worker.dart';
import '../../models/requestedGroceryItem.dart';
import '../../providers/user.dart';

class GroceryDeliveries extends StatefulWidget {
  const GroceryDeliveries({super.key});

  @override
  State<GroceryDeliveries> createState() => _GroceryDeliveriesState();
}

class _GroceryDeliveriesState extends State<GroceryDeliveries> {

  List<RequestedGroceryItem> requestedGroceryItems=[];
  List<RequestedGroceryItem> filteredRequestedGroceryItems=[];
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroceryRequestsForReliefWorker();
  }

  getGroceryRequestsForReliefWorker() async {
    ReliefWorkerService reliefWorkerService=ReliefWorkerService();
    requestedGroceryItems=await reliefWorkerService.getAllRequestedGroceryItemsForReliefWorker(UserProvider.userModel!.id);
    filteredRequestedGroceryItems=List.from(requestedGroceryItems);
    isLoading=false;
    setState(() {

    });
  }

  void filterItems(String query) {
    if (query.isEmpty || query == null) {
      filteredRequestedGroceryItems = List.from(requestedGroceryItems);
    } else {
      filteredRequestedGroceryItems = requestedGroceryItems
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
          : requestedGroceryItems.isEmpty
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
                itemCount: filteredRequestedGroceryItems.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                    final result=await  Navigator.push(context, MaterialPageRoute(builder: (context) => GroceryDeliveriesDetail(requestedGroceryItems:  filteredRequestedGroceryItems[index]),));
                      if(result==1){
                        getGroceryRequestsForReliefWorker();
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
                                child:  Image.asset('lib/assets/imgs/grocery.jpg')

                            ),
                          ),

                          Column(
                            children: [
                              Text(
                                filteredRequestedGroceryItems[index]!
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
                                filteredRequestedGroceryItems[index]!
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
