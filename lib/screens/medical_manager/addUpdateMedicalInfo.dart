import 'dart:async';
import 'dart:isolate';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_facility.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_facility.dart';
import 'package:smart_supply_chain_management_fyp/models/user.dart';
import 'package:smart_supply_chain_management_fyp/providers/add_medical.dart';
import '../../providers/add_grocery.dart';
import '../../providers/user.dart';
import '../../utils/address_picker.dart';
import '../../utils/format_time.dart';
import '../../utils/theme.dart';
import '../medical_facility_details.dart';
import 'main.dart';



class MedicalFacilityForm extends StatefulWidget {
  @override
  _MedicalFacilityFormState createState() => _MedicalFacilityFormState();
}

class _MedicalFacilityFormState extends State<MedicalFacilityForm> {
  final _formKey = GlobalKey<FormState>();

  String facilityName = '';
  String medicalFacilityEmail = '';
  String medicalFacilityPhone = '';
  int numberOfBeds = 0;
  int medicalStaff = 0;
  int availableMedicalEquipmentCount = 0;
  String inventoryDesc = '';
  String accessibility='';
  final List<String> facilityTypes = ['hospital', 'clinic', 'pharmacy'];
  final List<String> statuses = ['open', 'closed'];
List<UserModel> managers=[];



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

@override
void initState(){
  var androidSettings=AndroidInitializationSettings('@mipmap/ic_launcher');
  var intializationSettings=InitializationSettings(android:androidSettings);
   flutterLocalNotificationsPlugin.initialize(intializationSettings);
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    Provider.of<AddMedicalProvider>(context,listen:false).isLoading=false;
  });
}

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {

        Provider.of<AddMedicalProvider>(context,listen:false).selectedStartTime = DateTime(
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

        Provider.of<AddMedicalProvider>(context,listen:false).selectedEndTime = DateTime(
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
        if ( Provider.of<AddMedicalProvider>(context,listen:false).selectedStartTime == null ) {
          return 'Start time required';
        }
        if ( Provider.of<AddMedicalProvider>(context,listen:false).selectedEndTime == null) {
          return 'End time required';
        }

        return null;
      },
      onTap: () => onTimeSelected(),
    );
  }

  Future<void> _addDataToFirebase(MedicalFacility medicalFacility) async {
    RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
    final ReceivePort receivePort = ReceivePort();

    Isolate.spawn(_isolateFunction, {
      'medicalFacility': medicalFacility.toMap(),
      'sendPort': receivePort.sendPort,
      'rootIsolateToken':rootIsolateToken
    });

    receivePort.listen((dynamic message) {
      if (message is String && message == 'completed') {
        _showLocalNotification();
        Provider.of<AddMedicalProvider>(context,listen:false).isLoading=false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>       MedicalManagerMain(), ));
      }
    });
  }
   static void _isolateFunction(Map<String, dynamic> params) async {
     final medicalFacilityJson = params['medicalFacility'] as Map<String, dynamic>;
     final RootIsolateToken rootIsolateToken = params['rootIsolateToken'] as RootIsolateToken;
    final medicalFacility = MedicalFacility.fromMap(medicalFacilityJson);
    final SendPort sendPort = params['sendPort'] as SendPort;
print(medicalFacility.toMap());
    try {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
      await Firebase.initializeApp();
      MedicalFacilityService medicalFacilityService=MedicalFacilityService();
     await medicalFacilityService.addMedicalFacility(medicalFacility);
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
      '0', // Change to your desired channel ID
      '0', // Change to your desired channel name
      importance: Importance.high,
      icon: null,
        channelShowBadge: true,
      enableVibration: true,
      priority: Priority.max,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Show a notification
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (change as needed)
      'MedicalFacility', // Notification title
      'MedicalFacility Pending', // Notification message
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Facility Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Facility Name';
                  }
                  return null;
                },
                onSaved: (value) {
                  facilityName = value!;
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              ElevatedButton(onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPicker(medicalOrGroceryOrCamp:  'medical'),));
              }, child: Container(width:width,child: Center(child: Text('Pick Location'))))
              ,
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Facility Phone no'),
                keyboardType: TextInputType.phone, // Set keyboard type to phone
                validator: (value) {
                  String? phoneNumber = value?.trim();
                  if (phoneNumber == null || phoneNumber.isEmpty) {
                    return 'Phone Number is required';
                  }
                  if(phoneNumber!=null){

                    // Use a regular expression to validate the phone number format
                    if (!RegExp(r'^[0-9]{11}$').hasMatch(phoneNumber!)) {
                      return 'Use this format 03402132101';
                    }
                  }

                  return null;
                },
                onSaved: (value) {
                  medicalFacilityPhone = value!;
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Facility Email'),
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
                  medicalFacilityEmail = value!;
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Selector<AddMedicalProvider,String?>(
                selector: (p0, p1) => p1.selectedFacilityType,
                builder: (context, selectedFacilityType, child) =>DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Facility type is required';
                    }
                    return null;
                  },
                  value: selectedFacilityType,
                  items: facilityTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                      Provider.of<AddMedicalProvider>(context,listen:false).
                          selectedFacilityType = value!;

                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Facility Type'),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),

              Selector<AddMedicalProvider,String?>(
                selector: (p0, p1) => p1.selectedFacilityType,
                builder: (context, selectedFacilityType, child) => Visibility(
                  visible: selectedFacilityType=='hospital'?true:false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: width * 0.4,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Beds'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter No of Beds';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            numberOfBeds = int.parse(value!);
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * 0.4,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Medical Staff '),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Medical Staff';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            medicalStaff = int.parse(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              SizedBox(
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Available Equipment Count'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Available Medical Equipment';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    availableMedicalEquipmentCount = int.parse(value!) ;
                  },
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Selector<AddMedicalProvider,DateTime?>(
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
                  Selector<AddMedicalProvider,DateTime?>(
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
                maxLines: 5,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Description';
                  }
                  return null;
                },
                onSaved: (value) {
                  inventoryDesc = value!;
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Selector<AddMedicalProvider,String?>(
                selector: (p0, p1) => p1.selectedStatus,
                builder: (context, selectedStatus, child) =>  DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Status is required';
                    }
                    return null;
                  },
                  hint: Text('Status'),
                  value: selectedStatus,
                  items: statuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {

                      Provider.of<AddMedicalProvider>(context,listen:false). selectedStatus = value!;

                  },
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
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
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if(Provider.of<AddMedicalProvider>(context,listen:false).location!=''){
                      Provider.of<AddMedicalProvider>(context,listen:false).isLoading=true;
                      _formKey.currentState!.save();

                      MedicalFacility medicalFacility= MedicalFacility(id: '', managerId: UserProvider.userModel!.id, facilityName: facilityName, location: Provider.of<AddMedicalProvider>(context,listen:false).location,latitude: Provider.of<AddMedicalProvider>(context,listen:false).latitude,longitude: Provider.of<AddMedicalProvider>(context,listen:false).longitude, medicalFacilityEmail: medicalFacilityEmail, medicalFacilityPhone: medicalFacilityPhone, selectedFacilityType: Provider.of<AddMedicalProvider>(context,listen:false). selectedFacilityType, numberOfBeds: numberOfBeds, medicalStaff: medicalStaff, availableMedicalEquipmentCount: availableMedicalEquipmentCount, inventoryDesc: inventoryDesc, selectedStatus:  Provider.of<AddMedicalProvider>(context,listen:false).selectedStatus, accessibility: accessibility, selectedStartTime: Provider.of<AddMedicalProvider>(context,listen:false).selectedStartTime, selectedEndTime: Provider.of<AddMedicalProvider>(context,listen:false).selectedEndTime, approveOrDeny: 'pending');
                    await  _addDataToFirebase(medicalFacility);

    }
    else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pick Location')));
    }
                    }
                  },
                  child: Selector<AddMedicalProvider,bool>(
                    selector: (p0, p1) => p1.isLoading,
                    builder: (context, isLoading, child) =>  Center(
                        child: isLoading?CircularProgressIndicator(color: container_color):Text('Submit',
                            style: TextStyle(color: container_color))),
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
