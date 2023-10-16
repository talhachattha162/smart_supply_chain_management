import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/providers/add_grocery.dart';
import 'package:smart_supply_chain_management_fyp/providers/add_grocery.dart';
import 'package:smart_supply_chain_management_fyp/providers/add_grocery.dart';
import 'package:smart_supply_chain_management_fyp/providers/requestedLocations.dart';
import 'package:smart_supply_chain_management_fyp/providers/requestedLocations.dart';
import 'package:smart_supply_chain_management_fyp/providers/requestedLocations.dart';

import '../providers/add_camp.dart';
import '../providers/add_medical.dart';
import 'locationService.dart';

class AddressPicker extends StatefulWidget {
  String medicalOrGroceryOrCamp;
   AddressPicker({super.key,required this.medicalOrGroceryOrCamp});

  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
   double userLatitude=33.738045 ;
  late double userLongitude=73.084488 ;

   bool permissionDenied=false;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  OpenStreetMapSearchAndPick(
          center: LatLong(userLatitude, userLongitude),
          buttonColor: Colors.blue,
          locationPinText: '',
          buttonText: 'Set this Location',
       onGetCurrentLocationPressed: () async {
         LocationService locationService=LocationService();
         LatLng latLong=await locationService.getPosition();
         return latLong;
       },
      onPicked: (pickedData) {
        String addressString =
            pickedData.address['village'] ??
                pickedData.address['suburb'] ??
                pickedData.address['county'] ??
                pickedData.address['town'] ??
                pickedData.address['city'] ??
                pickedData.address['subdistrict'] ??
                pickedData.address['district'] ??
                pickedData.address['region'] ??
                pickedData.address.toString();
            if(widget.medicalOrGroceryOrCamp=='medical'){
              Provider.of<AddMedicalProvider>(context,listen:false).latitude=pickedData.latLong.latitude;
              Provider.of<AddMedicalProvider>(context,listen:false).longitude=pickedData.latLong.longitude;
              Provider.of<AddMedicalProvider>(context,listen:false).location=addressString;
            }
     if(widget.medicalOrGroceryOrCamp=='camp'){
       Provider.of<AddReliefCampProvider>(context,listen:false).latitude=pickedData.latLong.latitude;
       Provider.of<AddReliefCampProvider>(context,listen:false).longitude=pickedData.latLong.longitude;
       Provider.of<AddReliefCampProvider>(context,listen:false).location=addressString;
     }
            if(widget.medicalOrGroceryOrCamp=='grocery'){
              Provider.of<AddGroceryProvider>(context,listen:false).latitude=pickedData.latLong.latitude;
              Provider.of<AddGroceryProvider>(context,listen:false).longitude=pickedData.latLong.longitude;
              Provider.of<AddGroceryProvider>(context,listen:false).location=addressString;
            }
            if(widget.medicalOrGroceryOrCamp=='request'){
              Provider.of<RequestedLocationProvider>(context,listen:false).latitude=pickedData.latLong.latitude;
              Provider.of<RequestedLocationProvider>(context,listen:false).longitude=pickedData.latLong.longitude;
            }
            Navigator.pop(context,);
          }
          ),
    );
  }
}
