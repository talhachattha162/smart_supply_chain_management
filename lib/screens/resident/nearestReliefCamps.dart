import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_supply_chain_management_fyp/firebase/grocery_store.dart';
import 'package:smart_supply_chain_management_fyp/firebase/relief_camp.dart';
import 'package:smart_supply_chain_management_fyp/models/relief_camp.dart';
import 'package:smart_supply_chain_management_fyp/utils/locationService.dart';
import '../../models/grocery_store.dart';
import '../../utils/reliefcampicon.dart';
import '../grocery_store_details.dart';
import '../relief_camp_details.dart';

class NearestReliefCamps extends StatefulWidget {
  @override
  _NearestReliefCampsState createState() => _NearestReliefCampsState();
}

class _NearestReliefCampsState extends State<NearestReliefCamps> with WidgetsBindingObserver{
  late double userLatitude;
  late double userLongitude;
  final double maxDistance = 10000.0; //  10 km
  bool _isLoading = true;
  List<Marker> nearestCities = [];
  List<ReliefCamp> nearestCamps = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    findNearestCities();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this); // Remove the observer
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.resumed) {
      findNearestCities();
    }
  }

  getReliefCamps() async {
    ReliefCampService reliefCampService = ReliefCampService();
    List<ReliefCamp> ReliefCamps =
        await reliefCampService.getReliefCamps();
    return ReliefCamps;
  }

  void findNearestCities() async {
    //get lat long
    LocationService locationService = LocationService();
    LatLng latLong = await locationService.getPosition();

    userLatitude = latLong.latitude;
    userLongitude = latLong.longitude;

    //get grocery stores
    List<ReliefCamp> reliefCamps = await getReliefCamps();
    for (int i = 0; i < reliefCamps.length; i++) {

      nearestCamps.add(reliefCamps[i]);
    }
    nearestCities.clear();

    for (ReliefCamp nearestCamp in nearestCamps) {
      double cityLatitude = nearestCamp.latitude; // Replace with the latitude of the city
      double cityLongitude =
          nearestCamp.longitude; // Replace with the longitude of the city

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
                  Icon(Icons.local_hotel, color: Colors.deepPurpleAccent),

                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReliefCampDetails(reliefCamp: nearestCamp,appbar: true),))


        )
        ));
      }
    }
    _isLoading = false;
    setState(() {});
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
                          color: Colors.deepPurple,
                        ),
                        child: Icon(
                          Icons.local_hotel , // Replace with your desired icon
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
