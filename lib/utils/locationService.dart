import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {

  Future<LatLng> getPosition() async {

    // Check or request location permission
    LocationPermission permission = await Geolocator.checkPermission();

      while(permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
      }
if(permission == LocationPermission.deniedForever){
  await Geolocator.openAppSettings();
}


    bool servicestatus = await Geolocator.isLocationServiceEnabled();

    if(servicestatus){
      print("GPS service is enabled");
    }else{
      print("GPS service is disabled.");
      await Geolocator.openLocationSettings();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return LatLng(position.latitude, position.longitude);
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double pi = 3.1415926535897932;
    const double radius = 6371.0; // Earth radius in kilometers

    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);

    double a = pow(sin(dLat / 2), 2) +
        cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) * pow(sin(dLon / 2), 2);

    num c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radius * c;
  }

}