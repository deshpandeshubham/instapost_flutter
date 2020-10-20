import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:instapost/model/PostDetails.dart';
import 'package:instapost/nickname_posts.dart';
import 'package:instapost/post_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _character = "";

class AddRating extends StatefulWidget {
  final String postId;
  AddRating(this.postId);
  @override
  AddRatingState createState() => AddRatingState(postId);
}

class AddRatingState extends State<AddRating> {
  bool refreshPage = true;
  final String postId;
  AddRatingState(this.postId);
  String rating = "1";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Rating")),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              child: Text(
                "Rate the post",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RadioListTile(
                      title: Text(
                        "1",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      value: "1",
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          rating = value;
                          _character = value;
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        "2",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      value: "2",
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          rating = value;
                          _character = value;
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        "3",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      value: "3",
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          rating = value;
                          _character = value;
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        "4",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      value: "4",
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          rating = value;
                          _character = value;
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        "5",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      value: "5",
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          rating = value;
                          _character = value;
                        });
                      }),
                ],
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
                    child: Text('Rate'),
                    onPressed: () async {
                      await addRating(postId, rating);
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

Future<http.Response> addRating(String postId, String rating) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool trustSelfSigned = true;
  HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  IOClient ioClient = new IOClient(httpClient);

  final response = await ioClient.post(
      'https://bismarck.sdsu.edu/api/instapost-upload/rating',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': prefs.getString("email"),
        'password': prefs.getString("password"),
        'rating': int.parse(rating),
        'post-id': int.parse(postId),
      }));
  return response;
}
