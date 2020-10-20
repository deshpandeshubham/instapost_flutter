import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:instapost/post_details.dart';
import 'package:instapost/model/PostDetails.dart';

PostDetails postDetails;

class NickNamePosts extends StatelessWidget {
  final List<dynamic> posts;

  NickNamePosts(this.posts);
  
  @override  
  Widget build(BuildContext context) {  
     return Scaffold(  
      appBar: AppBar(  
        title: Text("Posts"),  
      ),  
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            margin: EdgeInsets.all(2),
            child: Center(
              child: tappableText('${posts[index]}', context)
            ),
          );
        } 
      )
    );  
  } 

  Widget tappableText(String postId, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await fetchPostDetails(postId).then((value) {});
        Route route = MaterialPageRoute(builder: (context) => PostDetailsPage(postDetails));
        Navigator.push(context, route);
      },
      child: Text(
        postId,
        style: TextStyle(fontSize: 20, color: Colors.blue),
      ),
    );
  } 

  static Future<Map> fetchPostDetails(String postId) async {
    final httpClient = new HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(httpClient);
    final response = await http.get('https://bismarck.sdsu.edu/api/instapost-query/post?post-id=$postId');
    Map map = json.decode(response.body);
    postDetails = PostDetails.fromJson(map['post']);
    postDetails.postId = int.parse(postId);
    return json.decode(response.body);
  }
}

