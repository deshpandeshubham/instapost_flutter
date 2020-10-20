import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:instapost/add_image.dart';
import 'package:instapost/nickname_posts.dart';
import 'package:instapost/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/Post.dart';

class CreatePost extends StatefulWidget {
  @override
  CreatePostState createState() {
    return CreatePostState();
  }
}

class CreatePostState extends State<CreatePost> {
  SharedPref sharedPref = SharedPref();
  String email;
  String password;
  Post postData=Post();
  
  Future<http.Response> addPost(Post postData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ioc = new HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    return http.post(
      'https://bismarck.sdsu.edu/api/instapost-upload/post',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        "email":prefs.getString("email"),
        "password":prefs.getString("password"),
        "text": postData.text,
        "hashtags": postData.hashtags,
      }),
    );
  }

  /*loadSharedPrefs() async {
    try {
      Post user = Post.fromJson(await sharedPref.read("postdata"));
      setState(() {
        postData=user;
        email=user.email;
        password=user.password;
      });
    } catch (Exception) {
      print("Unable to Load From Shared Preferences");
    }
  }*/

  List getHashTags(String text) {
    List<String> tags = [];
    RegExp exp = new RegExp(r"\B#\w\w+");
    exp.allMatches(text).forEach((match){
      tags.add(match.group(0));
    });
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Builder(
        builder: (context) =>  Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 80.0,
              width: 300.0,
              padding: EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(
                  height: 2.0
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                  labelText: "Post Text",
                ),
                onChanged: (value) {
                  setState(() {
                    postData.text = value;
                  });
                },
              )
            ),
            Container(
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () async{
                      postData.email=email;
                      postData.password=password;
                      postData.hashtags=getHashTags(postData.text);
                      var response = await addPost(postData);
                      Map responseMap = json.decode(response.body) as Map;
                      var postId = responseMap['id'];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddImage(postId)));
                    },
                    child: Text('Save Post', style: TextStyle(fontSize: 20,color:Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}