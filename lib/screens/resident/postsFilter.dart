import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/post.dart';

import '../../models/post.dart';

class PostsFilter extends StatefulWidget {

  const PostsFilter({super.key, required this.searchText});
  final String searchText;
  @override
  State<PostsFilter> createState() => _PostsFilterState();
}

class _PostsFilterState extends State<PostsFilter> {
  bool isLoading = true;
  List<Post> posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPostsByText();
  }

  getPostsByText() async {
    PostService postService = PostService();
    posts = await postService.fetchPostsContainingText(widget.searchText);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.searchText)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) =>
                  Column(
                    children: [
                      ListTile(title: Text(posts[index].postData),
                          // subtitle:
                      // Column(children: [
                      //   Text(posts[index].tags[0]),
                      //   Text(posts[index].tags[1]),
                      //   Text(posts[index].tags[2])
                      // ],)
                      ),
                      Divider()
                    ],
                  ),
            ),
    );
  }
}
