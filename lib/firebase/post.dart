import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post.dart';

class PostService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createPost(Post post) async {
    await firestore.collection('posts').add(post.toMap());
  }

  Future<void> updatePost(String postId, Post updatedPost) async {
    await firestore.collection('posts').doc(postId).update(updatedPost.toMap());
  }

  Future<void> deletePost(String postId) async {
    await firestore.collection('posts').doc(postId).delete();
  }

  Future<List<Post>> getPosts() async {
    QuerySnapshot querySnapshot = await firestore.collection('posts').get();
    List<Post> posts = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      posts.add(Post.fromMap(data));
    }

    return posts;
  }

  Future<List<Post>> fetchPostsContainingText(String searchText) async {

    CollectionReference collection = FirebaseFirestore.instance.collection('posts');

    QuerySnapshot querySnapshot = await collection.get();
    List<Post> filteredPosts=[];
    List<Post> posts=  querySnapshot.docs.map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>)).toList();
    for(Post post in posts){
      if(post.tags.contains(searchText)){
        filteredPosts.add(post);
      }
    }
    return filteredPosts;
  }


}
