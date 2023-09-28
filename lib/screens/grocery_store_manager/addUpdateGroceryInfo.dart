import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/utils/address_picker.dart';
import '../../firebase/grocery_store.dart';
import '../../models/grocery_store.dart';
import '../../providers/add_grocery.dart';
import '../../providers/user.dart';
import '../../utils/format_time.dart';
import '../../utils/theme.dart';
import 'main.dart';

class GroceryStoreForm extends StatefulWidget {
  @override
  _GroceryStoreFormState createState() => _GroceryStoreFormState();
}

class _GroceryStoreFormState extends State<GroceryStoreForm> {
  final _formKey = GlobalKey<FormState>();

  String storeName = '';
  String contactPhone = '';
  String contactEmail = '';
  String inventorydesc = '';
  // String? selectedStatus;
  String? accessibility;
  final List<String> storeTypes = ['Supermarket', 'Local Grocery Store'];
  final List<String> statuses = ['Open', 'Closed'];




  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    var androidSettings=AndroidInitializationSettings('@mipmap/ic_launcher');
    var intializationSettings=InitializationSettings(android:androidSettings);
    flutterLocalNotificationsPlugin.initialize(intializationSettings);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AddGroceryProvider>(context,listen:false).isLoading=false;
    });

  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      Provider.of<AddGroceryProvider>(context,listen:false).selectedStartTime=
          DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      Provider.of<AddGroceryProvider>(context,listen:false).selectedEndTime=
         DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
    }
  }


  TextFormField buildTimePickerFormField({
    String? labelText,
    DateTime? selectedTime,
    required void Function() onTimeSelected,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
      readOnly: true,
      controller: TextEditingController(
        text: selectedTime != null ? formatTime(selectedTime) : '',
      ),
      validator: (_) {
        if (Provider.of<AddGroceryProvider>(context,listen:false).selectedStartTime == null ) {
          return 'Start time required';
        }
        if (Provider.of<AddGroceryProvider>(context,listen:false).selectedEndTime == null) {
          return 'End time required';
        }

        return null;
      },
      onTap: () => onTimeSelected(),
    );
  }

  Future<void> _addDataToFirebase(GroceryStore groceryStore) async {
    RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
    final ReceivePort receivePort = ReceivePort();

    Isolate.spawn(_isolateFunction, {
      'GroceryStore': groceryStore.toMap(),
      'sendPort': receivePort.sendPort,
      'rootIsolateToken':rootIsolateToken
    });

    receivePort.listen((dynamic message) {
      if (message is String && message == 'completed') {
        _showLocalNotification();
        Provider.of<AddGroceryProvider>(context,listen:false).isLoading=false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>       GroceryStoreManagerMain(), ));
      }
    });
  }


  static void _isolateFunction(Map<String, dynamic> params) async {
    final groceryStoreJson = params['GroceryStore'] as Map<String, dynamic>;
    final RootIsolateToken rootIsolateToken = params['rootIsolateToken'] as RootIsolateToken;
    final groceryStore = GroceryStore.fromMap(groceryStoreJson);
    final SendPort sendPort = params['sendPort'] as SendPort;
    try {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
      await Firebase.initializeApp();
      GroceryStoreService groceryStoreService=GroceryStoreService();
      await groceryStoreService.addGroceryStore(groceryStore);
      sendPort.send('completed');
    } catch (e) {
      print("Error adding data to Firebase: $e");
      sendPort.send('completed'); // You can handle errors as needed
    }
  }


  Future<void> _showLocalNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Define notification details
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1',
        '1',
        importance: Importance.defaultImportance,
        icon: null
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Show a notification
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (change as needed)
      'GroceryStore', // Notification title
      'GroceryStore Pending', // Notification message
      platformChannelSpecifics,
    );
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.0),

        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Store Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Store Name';
                  }
                  return null;
                },
                onSaved: (value) {
                  storeName = value!;
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              ElevatedButton(onPressed: () async {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPicker(medicalOrGroceryOrCamp: 'grocery'),));
              }, child: Container(width:width,child: Center(child: Text('Pick Location')))),
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Grocery Phone no'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Phone no';
                  }
                  return null;
                },
                onSaved: (value) {
                  contactPhone = value!;
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Grocery Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email';
                  } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  contactEmail = value!;
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Selector<AddGroceryProvider,String?>(
                selector: (p0, p1) => p1.selectedStoreType,
                builder: (context, selectedStoreType, child) => DropdownButtonFormField<String>(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  hint: Text('Select Store Type'),
                  value: selectedStoreType,
                  items: storeTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {

                    Provider.of<AddGroceryProvider>(context,listen:false).
                        selectedStoreType = value!;

                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Store type is required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Inventory Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Inventory Description';
                  }
                  return null;
                },
                onSaved: (value) {
                  inventorydesc = value!;
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: width * 0.35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery'),
                    Selector<AddGroceryProvider,bool>(
                      selector: (p0, p1) => p1.hasDeliveryServices,
                          builder: (context, hasDeliveryServices, child) =>  Switch(
                            value: hasDeliveryServices,
                            onChanged: (value) {
    Provider.of<AddGroceryProvider>(context,listen:false).
                                hasDeliveryServices = value;
                           
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Selector<AddGroceryProvider,String?>(
                    selector: (p0, p1) => p1.selectedStatus,
                    builder: (context, selectedStatus, child) => SizedBox(
                      width: width * 0.45,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        hint: Text('Select Status'),
                        value: selectedStatus,
                        items: statuses.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
    Provider.of<AddGroceryProvider>(context,listen:false).
    selectedStatus = value!;
                         
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'status is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Selector<AddGroceryProvider,DateTime?>(
                    selector: (p0, p1) => p1.selectedStartTime,
                    builder: (context, selectedStartTime, child) => SizedBox(
                      width: width * 0.4,
                      child: buildTimePickerFormField(
                        labelText: 'Start Time',
                        selectedTime: selectedStartTime,
                        onTimeSelected: () => _selectStartTime(context),
                      ),
                    ),
                  ),
                  Selector<AddGroceryProvider,DateTime?>(
                    selector: (p0, p1) => p1.selectedEndTime,
                    builder: (context, selectedEndTime, child) => SizedBox(
                      width: width * 0.4,
                      child: buildTimePickerFormField(
                        labelText: 'End Time',
                        selectedTime: selectedEndTime,
                        onTimeSelected: () => _selectEndTime(context),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Accesibility'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Accesibility';
                  }
                  return null;
                },
                onSaved: (value) {
                  accessibility = value!;
                },
              ),

              SizedBox(
                height: height * 0.03,
              ),
              SizedBox(
                width: width*0.8,
                child: ElevatedButton(
                  onPressed:  () async {
                    if (_formKey.currentState!.validate()) {
                      if(Provider.of<AddGroceryProvider>(context,listen:false).location!='') {
                        Provider
                            .of<AddGroceryProvider>(context, listen: false)
                            .isLoading = true;
                        _formKey.currentState!.save();
                        GroceryStore groceryStore = GroceryStore(id: '',
                            managerId: UserProvider.userModel!.id,
                            storeName: storeName,
                            location: Provider
                                .of<AddGroceryProvider>(context, listen: false)
                                .location,
                            latitude: Provider
                                .of<AddGroceryProvider>(context, listen: false)
                                .latitude,
                            longitude: Provider
                                .of<AddGroceryProvider>(context, listen: false)
                                .longitude,
                            contactPhone: contactPhone,
                            contactEmail: contactEmail,
                            selectedStoreType: Provider
                                .of<AddGroceryProvider>(context, listen: false)
                                .selectedStoreType,
                            inventorydesc: inventorydesc,
                            hasDeliveryServices: Provider
                                .of<AddGroceryProvider>(context, listen: false)
                                .hasDeliveryServices,
                            selectedStatus: Provider
                                .of<AddGroceryProvider>(context, listen: false)
                                .selectedStatus,
                            accessibility: accessibility,
                            selectedStartTime: Provider
                                .of<AddGroceryProvider>(context, listen: false)
                                .selectedStartTime,
                            selectedEndTime: Provider
                                .of<AddGroceryProvider>(context, listen: false)
                                .selectedEndTime,
                            approveOrDeny: 'pending');
                        await _addDataToFirebase(groceryStore);
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pick Location')));
                      }
                    }
                  },
                  child: Selector<AddGroceryProvider,bool>(
                    selector: (p0, p1) => p1.isLoading,
                    builder: (context, isLoading, child) =>   Center(
                        child:isLoading?CircularProgressIndicator(color: Colors.white,): Text('Submit',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
