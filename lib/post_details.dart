import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:instapost/comment.dart';
import 'package:instapost/home_page.dart';
import 'package:instapost/model/PostDetails.dart';
import 'package:instapost/nicknames_page.dart';
import 'package:instapost/rating.dart';
import 'image.dart';
import 'nickname_posts.dart';

class PostDetailsPage extends StatefulWidget {
  final PostDetails postDetails;
  PostDetailsPage(this.postDetails);
  @override
  PostDetailsPageState createState() => PostDetailsPageState(postDetails);
}

class PostDetailsPageState extends State<PostDetailsPage> {  
  PostDetails postDetails;
  bool refreshPage;
  PostDetailsPageState(this.postDetails);
  @override  
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(  
        title: Text("Post Details"),  
      ),
      body: new FutureBuilder<Map>(
        future: null,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(2),
              child: Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Post Text : " + postDetails.postText,
                        style: TextStyle(fontSize: 20, color: Colors.blue)
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Ratings count : " + postDetails.ratingsCount.toString(),
                        style: TextStyle(fontSize: 20, color: Colors.blue)
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Rating average : " + postDetails.ratingsAvg.toString(),
                        style: TextStyle(fontSize: 20, color: Colors.blue)
                      ),
                      SizedBox(height: 20),
                      Text('HashTags', style: TextStyle(fontSize:20, color: Colors.blue)),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            for(var hashtag in postDetails.hashTags) new Text(hashtag, style: TextStyle(fontSize: 18))
                          ]
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Comments', style: TextStyle(fontSize:20, color: Colors.blue)),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            for(var comment in postDetails.comments) new Text(comment, style: TextStyle(fontSize: 18))
                          ],
                        ),
                      ),
                      SizedBox(height: 18),
                      RaisedButton(
                        padding: EdgeInsets.all(8.0),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddRating(postDetails.postId.toString())),
                          );
                        },
                        textColor: Colors.white,
                        color: Colors.blueAccent,
                        child: Text('Add Rating', style: TextStyle(fontSize: 20,color:Colors.white)),
                      ),
                      SizedBox(height: 18),
                      RaisedButton(
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddComment(postDetails.postId.toString()),)
                          );
                        },
                        textColor: Colors.white,
                        color: Colors.blueAccent,
                        child: Text('Add Comment', style: TextStyle(fontSize: 20,color:Colors.white)),
                      ),
                      SizedBox(height: 18),
                      RaisedButton(
                        padding: EdgeInsets.all(8.0),
                        onPressed: () async {
                          await getImage(postDetails.imageId).then((value) {
                            base64Image = value['image'];
                          });
                          Route route = MaterialPageRoute(builder: (context) => GetImage(base64Image));
                          Navigator.push(context, route);
                        },
                        textColor: Colors.white,
                        color: Colors.blueAccent,
                        child: Text('View Image', style: TextStyle(fontSize: 20)),
                      ),
                    ]
                  ),
                ),
              ),
            ),
          );
        },
      )
    );  
  }  

  Future<Map> getImage(int imageId) async {
    final httpClient = new HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(httpClient);
    final response = await http.get('https://bismarck.sdsu.edu/api/instapost-query/image?id=$imageId');
    return json.decode(response.body)  as Map;
  }
}