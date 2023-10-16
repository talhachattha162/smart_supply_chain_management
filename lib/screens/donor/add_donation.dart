import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/donation.dart';
import 'package:smart_supply_chain_management_fyp/models/donation.dart';
import 'package:smart_supply_chain_management_fyp/providers/medicalFacility.dart';
import 'package:smart_supply_chain_management_fyp/providers/user.dart';

import '../../firebase/medical_item.dart';
import '../../firebase/reliefCamp_item.dart';
import '../../models/medical_item.dart';
import '../../models/relief_camp_item.dart';
import '../../providers/relief_Camp.dart';

class AddDonation extends StatefulWidget {
  @override
  State<AddDonation> createState() => _AddDonationState();
}

class _AddDonationState extends State<AddDonation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String itemName = '';

  String brand = '';

  String description = '';

  String? unitOfMeasurement;

  int quantityInStock = 0;

  DateTime? expirationDate;


  List<String> unitOfMeasurementOptions = [
    'cases',
    'pallets',
    'tablet',
    'injection',
    'spray',
    'g',
    'kg',
    'pound',
    'l',
    'ml',
    'gallon',
    'dozen',
  ];



  bool isLoading = false;




  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add donation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Item Name
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Item Name *'),
                  onSaved: (value) {
                    itemName = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item name.';
                    }
                    return null;
                  },
                ),
                // Brand
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Brand *'),
                  onSaved: (value) {
                    brand = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter brand.';
                    }
                    return null;
                  },
                ),
                // Description
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Description *'),
                  onSaved: (value) {
                    description = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                // Unit of Measurement dropdown
                DropdownButtonFormField(
                  hint: Text('Unit Of Measurement'),
                  value: unitOfMeasurement,
                  items: unitOfMeasurementOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      unitOfMeasurement = value.toString();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select Unit';
                    }
                    return null;
                  },
                ),
                // Quantity in Stock

                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quantity in Stock *'),
                  onSaved: (value) {
                    quantityInStock = int.tryParse(value!)!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Expiration Date (YYYY-MM-DD) *',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text: expirationDate != null
                        ? '${expirationDate!.year}-${expirationDate!.month.toString().padLeft(2, '0')}-${expirationDate!.day.toString().padLeft(2, '0')}'
                        : '',
                  ),
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter date';
                    }
                    return null;
                  },
                ),
                // Additional Notes
                SizedBox(
                  height: height * 0.01,
                ),
                // Submit Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      isLoading=true;
                      setState(() {

                      });
                      Donation donation=Donation(itemName: itemName, brand: brand, description: description, quantityInStock: quantityInStock, donorId:  UserProvider.userModel!.id,  status: 'pending', id:'',expirationDate: expirationDate,unitOfMeasurement: unitOfMeasurement);
                      DonationService donationService=DonationService();
                     await donationService.addDonation(donation);
                      setState(() {

                      });
                      isLoading = false;
                      Navigator.pop(context);
                      setState(() {});
                    }
                  },
                  child: isLoading?
                  CircularProgressIndicator()
                      :
                  Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to show the date picker and update the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: expirationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != expirationDate)
      setState(() {
        expirationDate = picked;
      });
  }


}
