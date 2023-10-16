import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/donation.dart';
import 'package:smart_supply_chain_management_fyp/providers/user.dart';

import '../../models/donation.dart';


class ViewDonations extends StatefulWidget {


  @override
  _ViewDonationsState createState() => _ViewDonationsState();
}

class _ViewDonationsState extends State<ViewDonations> {
  
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
  donations= await donationService.getApprovedDonations(UserProvider.userModel!.id);
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
                    title: Row(
                      children: [
                        Text(filteredDonations[index].itemName),
                      ],
                    ),
                    subtitle:
                    Row(
                      children: [
                        Text('Quantity: ${filteredDonations[index].quantityInStock}'),
                      ],
                    ),
                    trailing:
                    Text('Approved')
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
