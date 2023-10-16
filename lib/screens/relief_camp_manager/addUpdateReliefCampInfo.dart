import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/providers/add_camp.dart';
import 'package:smart_supply_chain_management_fyp/screens/relief_camp_manager/main.dart';
import '../../firebase/relief_camp.dart';
import '../../models/relief_camp.dart';
import '../../providers/user.dart';
import '../../utils/address_picker.dart';
import '../../utils/theme.dart';

class ReliefCampForm extends StatefulWidget {
  @override
  _ReliefCampFormState createState() => _ReliefCampFormState();
}

class _ReliefCampFormState extends State<ReliefCampForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 late String campName;
 late String email;
 late String phoneNumber;
 late String description;


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    var androidSettings=AndroidInitializationSettings('@mipmap/ic_launcher');
    var intializationSettings=InitializationSettings(android:androidSettings);
    flutterLocalNotificationsPlugin.initialize(intializationSettings);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AddReliefCampProvider>(context,listen:false).isLoading=false;
    });

  }

  Future<void> _addDataToFirebaseIsolate(ReliefCamp reliefCamp) async {
    RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
    final ReceivePort receivePort = ReceivePort();

    Isolate.spawn(_isolateFunction, {
      'reliefCamp': reliefCamp.toMap(),
      'sendPort': receivePort.sendPort,
      'rootIsolateToken':rootIsolateToken
    });

    receivePort.listen((dynamic message) {
      if (message is String && message == 'completed') {
        _showLocalNotification("Data added to Firebase");
        Provider.of<AddReliefCampProvider>(context,listen:false).isLoading=false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>       ReliefCampManagerMain(), ));

      }
    });
  }
  static void _isolateFunction(Map<String, dynamic> params) async {
    final reliefCampJson = params['reliefCamp'] as Map<String, dynamic>;
    final RootIsolateToken rootIsolateToken = params['rootIsolateToken'] as RootIsolateToken;
    final reliefCamp = ReliefCamp.fromMap(reliefCampJson);
    final SendPort sendPort = params['sendPort'] as SendPort;

    try {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
      await Firebase.initializeApp();
      ReliefCampService reliefCampService=ReliefCampService();
      await reliefCampService.addReliefCamp(reliefCamp);
      sendPort.send('completed');
    } catch (e) {
      print("Error adding data to Firebase: $e");
      sendPort.send('completed'); // You can handle errors as needed
    }
  }

  Future<void> _showLocalNotification(String s) async {
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
      'Relief Camp', // Notification title
      'Relief Camp Pending', // Notification message
      platformChannelSpecifics,
    );
  }




  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return  SafeArea(
      child: Scaffold(

        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Camp Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Camp Name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      campName = value!;
                    },
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  ElevatedButton(onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPicker(medicalOrGroceryOrCamp: 'camp'),));
                  }, child: Container(width:width,child: Center(child: Text('Pick Location')))),

                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Phone Number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneNumber = value!;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      description = value!;
                    },
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  SizedBox(
                    child: ElevatedButton(
                      onPressed:  () async {
                        if (_formKey.currentState!.validate()) {
                          if(Provider.of<AddReliefCampProvider>(context,listen:false).location!=''){
                          Provider.of<AddReliefCampProvider>(context,listen:false).isLoading=true;
                          _formKey.currentState!.save();
                          ReliefCamp reliefCamp=ReliefCamp(id: '', campName: campName, location: Provider.of<AddReliefCampProvider>(context,listen:false).location, email: email, phoneNumber: phoneNumber, description: description, approveOrDeny: 'pending',managerId: UserProvider.userModel!.id,longitude: Provider.of<AddReliefCampProvider>(context,listen:false).longitude,latitude: Provider.of<AddReliefCampProvider>(context,listen:false).latitude);
                          await _addDataToFirebaseIsolate(reliefCamp);
                        }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pick Location')));
                          }
                        }

                      },
                      child: Selector<AddReliefCampProvider,bool>(
                          selector: (p0, p1) => p1.isLoading,
                          builder: (context, isLoading, child) =>
                         isLoading?Center(child: CircularProgressIndicator(color: container_color,)): Center(
                            child: Text('Submit',
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
        ),
      ),
    );
  }
}

