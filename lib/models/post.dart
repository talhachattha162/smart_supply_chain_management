import 'package:smart_supply_chain_management_fyp/models/tag.dart';

class Post {
  String postData;
  DateTime dateTime;
  double lat;
  double long;
List<String> tags;
  Post({
    required this.postData,
    required this.dateTime,
    required this.lat,
    required this.long ,
    required this.tags
  });

  Map<String, dynamic> toMap() {
    return {
      'post': postData,
      'dateTime': dateTime.toIso8601String(),
      'lat': lat,
      'long': long,
      'tags': tags,
    };
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      postData: map['post'],
      dateTime: DateTime.parse(map['dateTime']),
      lat: map['lat'] ,
      long: map['long'] ,
      tags:  (map['tags'] as List).cast<String>(),
    );
  }
}
