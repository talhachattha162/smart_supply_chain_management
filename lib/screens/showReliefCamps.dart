import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_details.dart';

import '../firebase/relief_camp.dart';
import '../models/relief_camp.dart';

class ShowReliefCamps extends StatefulWidget {
  const ShowReliefCamps({super.key});

  @override
  State<ShowReliefCamps> createState() => _ShowReliefCampsState();
}

class _ShowReliefCampsState extends State<ShowReliefCamps> {

  List<ReliefCamp> reliefCamps=[];
  List<ReliefCamp> filteredReliefCamps=[];
bool isLoading=true;
  @override
  initState(){
    super.initState();
    getReliefCamps();
  }

  getReliefCamps() async {
    ReliefCampService reliefCampService = ReliefCampService();
    List<ReliefCamp> reliefCampstemp = await reliefCampService.getReliefCamps();
    reliefCamps=reliefCampstemp;
    filteredReliefCamps=List.from(reliefCamps);
    isLoading=false;
    setState(() {
    });
  }

  void filterItems(String query) {
    if (query.isEmpty || query == null) {
      filteredReliefCamps = List.from(reliefCamps);
    } else {
      filteredReliefCamps = reliefCamps
          .where((item) =>
      item.campName!.toLowerCase().contains(query.toLowerCase())
      )
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body:
      isLoading?
          Center(child: CircularProgressIndicator(),)
          :
      reliefCamps.isEmpty?
      Center(child: Text('No relief Camps found'),)
          :
      Padding(
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
SizedBox(height: height*0.01,),
            SizedBox(
              height: height*0.75,
              child: ListView.builder(
                itemCount:filteredReliefCamps.length ,
                itemBuilder: (context, index) {
                  return                       Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReliefCampDetails(reliefCamp:reliefCamps[index] ,appbar: false),));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Image.asset(
                                    'lib/assets/imgs/relief-camp.png'

                                    ,fit: BoxFit.fill,),
                                ),
                                radius: 50,
                              ),

                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        filteredReliefCamps[index]!.campName,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),


                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.timelapse),
                                      Text('Opening Hours 24/7'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined),
                                      Text(filteredReliefCamps[index].location.length <= 30
                                          ? filteredReliefCamps[index].location
                                          : filteredReliefCamps[index].location.substring(0, 30)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height*0.01,),

                    ],
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
