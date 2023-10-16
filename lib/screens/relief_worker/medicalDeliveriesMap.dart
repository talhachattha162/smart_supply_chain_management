import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:latlong2/latlong.dart';

import '../../utils/locationService.dart';

class DeliveryMap extends StatefulWidget {
  final LatLng destinationPosition;

  DeliveryMap({
    required this.destinationPosition,
  });

  @override
  State<DeliveryMap> createState() => _DeliveryMapState();
}

class _DeliveryMapState extends State<DeliveryMap> {
    late LatLng initialPosition;
    bool isLoading=true;
    double distance=0.0;
    String duration='';
  @override
  void initState(){
    getLocation();
  }


  getLocation() async {
    LocationService locationService = LocationService();
    LatLng latLong = await locationService.getPosition();
    initialPosition=latLong;
    isLoading=false;
    setState(() {

    });
  }

    String formatDuration(double durationInSeconds) {
      int hours = (durationInSeconds / 3600).floor();
      int minutes = ((durationInSeconds / 60) % 60).floor();
      return '$hours hours $minutes minutes';
    }

    Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf624890ac7b916e2d45019ec7b375f08b83ff&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coordinates = data['features'][0]['geometry']['coordinates'] as List;
        // Assuming jsonData is the parsed JSON data

         distance = data['features'][0]['properties']['segments'][0]['distance'] / 1000.0; // Distance in kilometers
        double time = data['features'][0]['properties']['segments'][0]['duration']; // Duration in seconds

 duration=formatDuration(time);

        return coordinates.map((c) => LatLng(c[1], c[0])).toList();
      } else {
        print('Failed to load route: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load route: $e');
    }

    return []; // Return an empty list if the request fails
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
      isLoading?
          Center(child: CircularProgressIndicator())
          :
      FutureBuilder<List<LatLng>>(
        future: getRoute(initialPosition, widget.destinationPosition),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: initialPosition,
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: initialPosition,
                          builder: (ctx) => Container(
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.blue,
                              size: 40.0,
                            ),
                          ),
                        ),
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: widget.destinationPosition,
                          builder: (ctx) => Container(
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: snapshot.data ?? [],
                          strokeWidth: 2.0,
                          color: Colors.blue,
                        ),
                      ],
                    ),

                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40)),
                        color: Colors.black38,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Distance: ${distance.toStringAsFixed(2)} km',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Duration: $duration',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // A CircularProgressIndicator is displayed while waiting
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
