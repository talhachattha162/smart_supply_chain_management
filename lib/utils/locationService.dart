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
}