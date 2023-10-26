import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/post.dart';

import '../../models/post.dart';
import 'dart:math';

class PostsFilter extends StatefulWidget {
  const PostsFilter({Key? key, required this.searchText, required this.userLatitude, required this.userLongitude}) : super(key: key);
  final String searchText;
  final double userLatitude;
  final double userLongitude;

  @override
  _PostsFilterState createState() => _PostsFilterState();
}

class _PostsFilterState extends State<PostsFilter> {
  bool isLoading = true;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getPostsByDistanceAndDate();
  }

  getPostsByDistanceAndDate() async {
    PostService postService = PostService();
    posts = await postService.fetchPostsContainingText(widget.searchText);

    // User's coordinates are provided in the constructor
    double userLatitude = widget.userLatitude;
    double userLongitude = widget.userLongitude;

    // Calculate the date 7 days ago
    DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));

    // Filter posts within 10 km and posted in the last 7 days
    List<Post> filteredPosts = [];
    for (Post post in posts) {
      double distance = calculateDistance(userLatitude, userLongitude, post.lat, post.long);

      if (distance <= 10.0 && post.dateTime.isAfter(sevenDaysAgo)) {
        filteredPosts.add(post);
      }
    }

    setState(() {
      posts = filteredPosts;
      isLoading = false;
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371; // Earth's radius in km
    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);
    double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radius * c;
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.searchText)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => Column(
          children: [
            ListTile(
              title: Text(posts[index].postData),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
