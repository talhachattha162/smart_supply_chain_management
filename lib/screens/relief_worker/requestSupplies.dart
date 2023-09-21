import 'package:flutter/material.dart';

import '../../utils/theme.dart';



class RWSupplyRequestForm extends StatefulWidget {
  @override
  _RWSupplyRequestFormState createState() => _RWSupplyRequestFormState();
}

class _RWSupplyRequestFormState extends State<RWSupplyRequestForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _requestID;
  String? _requesterName;
  String? _requesterLocation;
  String? _supplyCategory;
  String? _supplyDetails;
  String? _urgencyLevel;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Request Supplies',
            ),
            backgroundColor: Colors.transparent),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Request ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Request ID';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _requestID = value;
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Requester Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Requester Name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _requesterName = value;
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Requester Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Requester Location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _requesterLocation = value;
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Supply Category',
                    border: OutlineInputBorder(),
                  ),
                  value: _supplyCategory,
                  items: ['Medical', 'Food', 'Shelter'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  validator: (value) {
                    if (_supplyCategory == null) {
                      return 'Please select a Supply Category';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _supplyCategory = value;
                    });
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Supply Details',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Supply Details';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _supplyDetails = value;
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Urgency Level',
                    border: OutlineInputBorder(),
                  ),
                  value: _urgencyLevel,
                  items: ['Critical', 'High', 'Normal'].map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  validator: (value) {
                    if (_urgencyLevel == null) {
                      return 'Please select an Urgency Level';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _urgencyLevel = value;
                    });
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: button_color,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(
                        color: button_color, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    height: height * 0.07,
                    width: width,
                    child: const Center(
                        child: Text('Submit',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
