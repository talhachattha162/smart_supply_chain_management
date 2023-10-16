import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/reliefCamp_item.dart';
import 'package:smart_supply_chain_management_fyp/models/relief_camp_item.dart';
import 'package:smart_supply_chain_management_fyp/providers/relief_Camp.dart';

import '../../firebase/donation.dart';
import '../../models/donation.dart';
import '../../providers/user.dart';

class ApproveAndDenyDonation extends StatefulWidget {
  const ApproveAndDenyDonation({super.key});

  @override
  State<ApproveAndDenyDonation> createState() => _ApproveAndDenyDonationState();
}

class _ApproveAndDenyDonationState extends State<ApproveAndDenyDonation> {


  String searchText = '';
  List<Donation> donations=[];
  List<Donation> filteredDonations=[];
bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDonors();
  }

  getDonors() async {
    DonationService donationService=DonationService();
    donations= await donationService.getDonations();
    filteredDonations = List.from(donations);
    isLoading=false;
    setState(() {
    });
  }


  void filterItems(String query) {
    if (query.isEmpty || query == null) {
      filteredDonations = List.from(donations);
    } else {
      filteredDonations = donations
          .where((item) =>
      item.itemName!.toLowerCase().contains(query.toLowerCase()) ||
          item.brand!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Donations'),
      ),
      body:
          isLoading?
              Center(child: CircularProgressIndicator())
              :
      donations.isEmpty?
          Center(child: Text('Nothing found'),)
          :
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterItems(value);
              },
              decoration: InputDecoration(
                hintText: 'Search by Item Name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDonations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredDonations[index].itemName),
                  subtitle:                   Text('Quantity: ${filteredDonations[index].quantityInStock}'),

                  trailing:
                  filteredDonations[index].status=='approved'?
                      Text('Approved')
                      :
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

                    ];
                  },
                      onSelected: (String value) async {
                        DonationService donationService=DonationService();
                        ReliefCampItemService reliefCampItemService=ReliefCampItemService();
                        Donation donation=filteredDonations[index];
                        ReliefCampItem reliefCampItem=ReliefCampItem(id: '', campId: ReliefCampProvider.reliefCamp!.id, itemName: filteredDonations[index].itemName, brand: filteredDonations[index].brand, description: filteredDonations[index].description, unitOfMeasurement: filteredDonations[index].unitOfMeasurement, quantityInStock: filteredDonations[index].quantityInStock, reorderLevel: 0, suppliername: '', supplieremail: '', supplierphone: '', shelfLocation: '', stockStatus: '', expirationDate: filteredDonations[index].expirationDate, additionalNotes: '');
                        switch (value) {
                          case 'Approve':
                            donation.status='approved';
                           await donationService.updateDonation(donation);
                           await reliefCampItemService.addReliefCampItem(reliefCampItem);
                           setState(() {
                           });
                            break;
                          case 'Deny':
                            donation.status='denied';
                            await donationService.updateDonation(donation);
                            setState(() {
                            });
                            break;
                            case 'Details':
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => GroceryStoreDetails(groceryStore: groceryStore,appbar:true),));
                            break;
                        }
                      })
                  // Add more details as needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }



}
