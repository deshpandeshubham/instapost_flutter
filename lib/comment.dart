import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:instapost/nickname_posts.dart';
import 'package:instapost/post_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/PostDetails.dart';

var commentController = new TextEditingController();

class AddComment extends StatefulWidget {
  final String postId;
  AddComment(this.postId);
  @override
  AddCommentState createState() => AddCommentState(postId);
}

class AddCommentState extends State<AddComment> {
  final String postId;
  AddCommentState(this.postId);
  String comment = "1";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Comment")),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              child: Text(
                "Comment on the post",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                controller: commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your comment',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Comment cannot be empty!';
                  }
                  return null;
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Center(
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Post'),
                    onPressed: () async {
                      await addComment(postId, commentController.text);
                      await NickNamePosts.fetchPostDetails(postId.toString()).then((value) => {
                        postDetails=PostDetails.fromJson(value['post']),
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsPage(postDetails)));
                    }),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Center(
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<http.Response> addComment(String postId, String comment) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool trustSelfSigned = true;
  HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  IOClient ioClient = new IOClient(httpClient);
  final response = await ioClient.post(
      'https://bismarck.sdsu.edu/api/instapost-upload/comment',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': prefs.getString("email"),
        'password': prefs.getString("password"),
        'comment': comment,
        'post-id': int.parse(postId),
      }));
  return response;
}
