import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_supply_chain_management_fyp/firebase/medical_facility.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_facility.dart';
import 'package:smart_supply_chain_management_fyp/screens/medical_facility_details.dart';
import 'package:smart_supply_chain_management_fyp/utils/locationService.dart';



class NearestMedicalFacility extends StatefulWidget {
  @override
  _NearestMedicalFacilityState createState() => _NearestMedicalFacilityState();
}

class _NearestMedicalFacilityState extends State<NearestMedicalFacility> with WidgetsBindingObserver{

  late double userLatitude;
  late double userLongitude;
  final double maxDistance = 10000.0; //  10 km
  bool _isLoading = true;
  List<Marker> nearestCities = [];
  List<MedicalFacility> nearestMedicalFacilities = [];
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    findNearestCities();
  }

  getMedicalFacilities() async {
    MedicalFacilityService medicalFacilityService=MedicalFacilityService();
    List<MedicalFacility> medicalFacilities =
    await medicalFacilityService.getMedicalFacilities();
    return medicalFacilities;
  }

  void findNearestCities() async {
    //get lat long
    LocationService locationService = LocationService();
    LatLng latLong = await locationService.getPosition();
    userLatitude = latLong.latitude;
    userLongitude = latLong.longitude;

    //get medical facility
    List<MedicalFacility> medicalFacilities = await getMedicalFacilities();
    for (int i = 0; i < medicalFacilities.length; i++) {
      nearestMedicalFacilities.add(medicalFacilities[i]);
    }

    nearestCities.clear();

    for (MedicalFacility medicalFacility in nearestMedicalFacilities) {
      double cityLatitude = medicalFacility.latitude; // Replace with the latitude of the city
      double cityLongitude = medicalFacility.longitude; // Replace with the longitude of the city

      double distance = calculateDistance(
        userLatitude,
        userLongitude,
        cityLatitude,
        cityLongitude,
      );

      if (distance <= maxDistance) {
        nearestCities.add(Marker(
          point: LatLng(cityLatitude, cityLongitude),
          builder: (context) =>
              IconButton(
              icon:
              Icon(Icons.medical_services_outlined, color: Colors.redAccent),

              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalFacilityDetails(medicalFacility:medicalFacility,appbar: true, ),))),
        ));
      }
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this); // Remove the observer
    super.dispose();
  }

  double calculateDistance(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const double earthRadius = 6371000.0; // Earth's radius in meters
    double lat1Radians = degreesToRadians(lat1);
    double lon1Radians = degreesToRadians(lon1);
    double lat2Radians = degreesToRadians(lat2);
    double lon2Radians = degreesToRadians(lon2);

    double dlat = lat2Radians - lat1Radians;
    double dlon = lon2Radians - lon1Radians;

    double a = sin(dlat / 2) * sin(dlat / 2) +
        cos(lat1Radians) * cos(lat2Radians) * sin(dlon / 2) * sin(dlon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.resumed) {
      findNearestCities();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Cities'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : FlutterMap(
        options: MapOptions(center: LatLng(userLatitude, userLongitude)),
        children: <Widget>[
          TileLayer(
            urlTemplate:
            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 45,
              size: const Size(40, 40),
              anchor: AnchorPos.align(AnchorAlign.center),
              fitBoundsOptions: const FitBoundsOptions(
                padding: EdgeInsets.all(50),
                maxZoom: 15,
              ),
              markers: nearestCities,
              builder: (context, markers) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.redAccent,
                  ),
                  child: Icon(
                    Icons.local_hospital_outlined, // Replace with your desired icon
                    color: Colors.white,
                    size: 22, // Adjust the size as needed
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}
