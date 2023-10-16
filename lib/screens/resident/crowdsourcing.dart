import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_supply_chain_management_fyp/firebase/post.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/add_post.dart';
import 'package:smart_supply_chain_management_fyp/screens/resident/postsFilter.dart';
import 'package:smart_supply_chain_management_fyp/utils/locationService.dart';
import 'package:http/http.dart' as http;
import '../../models/post.dart';
import '../../models/tag.dart';

class TagWithOccurrences {
  final String name;
  int occurrences;

  TagWithOccurrences({required this.name, this.occurrences = 1});
}


class Trends extends StatefulWidget {
  const Trends({super.key});

  @override
  State<Trends> createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {
  late LatLng userPosition;
  List<String> trend = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrends();
  }

  getPosts() async {
    PostService postService = PostService();
    List<Post> posts = await postService.getPosts();
    return posts;
  }


  Future<void> getTrends() async {
    isLoading = true;
    setState(() {});

    // Get the user's position
    LocationService locationService = LocationService();
    LatLng userPosition = await locationService.getPosition();

    // Get the current timestamp and the timestamp 7 days ago
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

    // Filter posts within a 10 km radius and from the past 7 days
    List<Post> posts = await getPosts();
    List<Post> filteredPosts = posts.where((post) {
      double distance = locationService.calculateDistance(
        userPosition.latitude,
        userPosition.longitude,
        post.lat,
        post.long,
      );

      return distance <= 10.0 && post.dateTime.isAfter(sevenDaysAgo);
    }).toList();

    // Calculate tag occurrences for the filtered posts
    Map<String, int> tagMap = {};
    for (Post post in filteredPosts) {
      for (var tag in post.tags) {
        if (tagMap.containsKey(tag)) {
          tagMap[tag] = tagMap[tag]! + 1;
        } else {
          tagMap[tag] = 1;
        }
      }
    }

    // Sort the tags by occurrences and take the top 10
    var sortedTags = tagMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    var top10Tags = sortedTags.take(10);

    // Extract the trend from the top 10 tags
    trend.clear();
    for (var entry in top10Tags) {
      trend.add(entry.key);
    }

    isLoading = false;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Trends'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        final result= await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPost(),
              ));
        if(result==1){
          getTrends();
        }
        },
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          :
          trend.isEmpty?
              Center(child: Text('No trends found'),)
              :
      Container(
              padding: EdgeInsets.all(10),
              height: height,
              child: ListView.builder(
                itemCount: trend.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostsFilter(
                                  searchText: trend[index]),
                            ));
                      },
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(trend[index]),
                          ),
                          Divider()
                        ],
                      ));
                },
              ),
            ),
    );
  }

}
