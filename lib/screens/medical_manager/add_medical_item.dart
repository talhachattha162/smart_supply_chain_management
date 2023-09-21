import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_item.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';

import '../../firebase/medical_facility.dart';

class ReliefItemForm extends StatefulWidget {
  @override
  _ReliefItemFormState createState() => _ReliefItemFormState();
}

class _ReliefItemFormState extends State<ReliefItemForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String itemName='';
  String brand='';
  String description='';
  String unitOfMeasurement='';
  int quantityInStock=0;
  int reorderLevel=0;
  String supplier='';
  String supplierContactName='';
  String supplierContactPhone='';
  String supplierContactEmail='';
  String shelfLocation='';
  String stockStatus='';
  DateTime? expirationDate;
  String additionalNotes='';
bool isLoading=true;

  List<String> unitOfMeasurementOptions = ['cases', 'pallets', 'individual units'];
  List<String> stockStatusOptions = ['In Stock', 'Out of Stock', 'Awaiting Delivery'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relief Item Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Item Name
              TextFormField(
                decoration: InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  itemName = value!;
                },
              ),
              // Brand
              TextFormField(
                decoration: InputDecoration(labelText: 'Brand'),
                onSaved: (value) {
                  brand = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the brand name.';
                  }
                  return null;
                },
              ),
              // Description
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  description = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description.';
                  }
                  return null;
                },
              ),
              // Unit of Measurement dropdown
              DropdownButtonFormField(
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
                decoration: InputDecoration(labelText: 'Unit of Measurement'),
              ),
              // Quantity in Stock
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity in Stock'),
                onSaved: (value) {
                  quantityInStock = int.tryParse(value!)!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantityInStock.';
                  }
                  return null;
                },
              ),
              // Reorder Level
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Reorder Level'),
                onSaved: (value) {
                  reorderLevel = int.tryParse(value!)!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reorderLevel.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Supplier Name'),
                onSaved: (value) {
                  supplierContactName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter supplier name.';
                  }
                  return null;
                },
              ),
              // Supplier Contact Phone
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Supplier Phone'),
                onSaved: (value) {
                  supplierContactPhone = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter supplier phone.';
                  }
                  return null;
                },
              ),
              // Supplier Contact Email
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Supplier Contact Email'),
                onSaved: (value) {
                  supplierContactEmail = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter supplier email.';
                  }
                  return null;
                },
              ),
              // Shelf Location
              TextFormField(
                decoration: InputDecoration(labelText: 'Shelf Location'),
                onSaved: (value) {
                  shelfLocation = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter shelfLocation';
                  }
                  return null;
                },
              ),
              // Stock Status dropdown
              DropdownButtonFormField(
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
                decoration: InputDecoration(labelText: 'Stock Status'),
              ),
              // Expiration Date
              TextFormField(
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(labelText: 'Expiration Date (YYYY-MM-DD)'),
                onSaved: (value) {
                  expirationDate = DateTime.tryParse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date';
                  }
                  return null;
                },
              ),
              // Additional Notes
              TextFormField(
                decoration: InputDecoration(labelText: 'Additional Notes'),
                onSaved: (value) {
                  additionalNotes = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Notes';
                  }
                  return null;
                },
              ),
              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      MedicalItemService medicalItemService=MedicalItemService();
      MedicalItem medicalItem=MedicalItem(id: '', hospitalId: 'hospitalId', itemName: itemName, brand: brand, description: description, unitOfMeasurement: unitOfMeasurement, quantityInStock: quantityInStock, reorderLevel: reorderLevel, suppliername: supplierContactName, supplierphone: supplierContactPhone,supplieremail: supplierContactEmail, shelfLocation: shelfLocation, stockStatus: stockStatus, expirationDate: expirationDate, additionalNotes: additionalNotes);
      medicalItemService.addMedicalItem(medicalItem);
      isLoading=false;
      setState(() {

      });
    }
  }
}
