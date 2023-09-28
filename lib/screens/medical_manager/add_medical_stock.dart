import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/providers/medicalFacility.dart';

import '../../firebase/medical_item.dart';
import '../../models/medical_item.dart';

class AddMedicalStock extends StatefulWidget {
  @override
  State<AddMedicalStock> createState() => _AddMedicalStockState();
}

class _AddMedicalStockState extends State<AddMedicalStock> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String itemName = '';

  String brand = '';

  String description = '';

  String? unitOfMeasurement;

  int quantityInStock = 0;

  int reorderLevel = 0;

  String supplier = '';

  String supplierContactName = '';

  String supplierContactPhone = '';

  String supplierContactEmail = '';

  String shelfLocation = '';

  String? stockStatus ;

  DateTime? expirationDate;

  String additionalNotes = '';

  bool isLoading = false;

  List<String> unitOfMeasurementOptions = [
    'cases',
    'pallets',
    'tablet',
    'injection',
    'spray',
    'g',
    'ml'
  ];

  List<String> stockStatusOptions = [
    'In Stock',
    'Out of Stock',
    'Awaiting Delivery'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Items'),
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
                // Reorder Level
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Reorder Level'),
                  onSaved: (value) {
                    reorderLevel = int.tryParse(value ?? '0') ?? 0;

                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Supplier Name'),
                  onSaved: (value) {
                    supplierContactName = value ?? '';
                  },
                ),
                // Supplier Contact Phone
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Supplier Phone'),
                  onSaved: (value) {
                    supplierContactPhone = value  ?? '';
                  },
                ),
                // Supplier Contact Email
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Supplier Contact Email'),
                  onSaved: (value) {
                    supplierContactEmail = value  ?? '';
                  },
                ),
                // Shelf Location
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Shelf Location',),
                  onSaved: (value) {
                    shelfLocation = value  ?? '';
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                // Stock Status dropdown
                DropdownButtonFormField(
                  hint: Text('Stock Status'),
                  value: stockStatus,
                  items: stockStatusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      stockStatus = value.toString();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select status';
                    }
                    return null;
                  },
                ),
                // Expiration Date
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
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Additional Notes'),
                  onSaved: (value) {
                    additionalNotes = value  ?? '';
                  },
                ),
                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
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


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      print('talha');
      _formKey.currentState!.save();
isLoading=true;
      setState(() {

});
      MedicalItemService medicalItemService = MedicalItemService();
      MedicalItem medicalItem = MedicalItem(
          id: '',
          hospitalId: MedicalFacilityProvider.medicalFacility!.id,
          itemName: itemName,
          brand: brand,
          description: description,
          unitOfMeasurement: unitOfMeasurement,
          quantityInStock: quantityInStock,
          reorderLevel: reorderLevel,
          suppliername: supplierContactName,
          supplierphone: supplierContactPhone,
          supplieremail: supplierContactEmail,
          shelfLocation: shelfLocation,
          stockStatus: stockStatus,
          expirationDate: expirationDate,
          additionalNotes: additionalNotes);
     await medicalItemService.addMedicalItem(medicalItem);
      isLoading = false;
      setState(() {});
    }
  }
}
