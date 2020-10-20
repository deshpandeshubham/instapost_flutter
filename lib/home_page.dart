import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:instapost/hashtags_page.dart';
import 'dart:convert';
import 'package:instapost/model/User.dart';
import 'package:instapost/image.dart';
import 'package:instapost/nicknames_page.dart';
import 'add_post.dart';

class HomePage extends StatefulWidget {
  final String userName;
  
  HomePage(this.userName);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

List<dynamic> nickNamesList = [];
List<dynamic> hashTagsList = [];
String base64Image = "";

class HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('InstaPost')),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30,70,30,30),
        child: ListView(
          children: <Widget>[
            Center(
              child: Text(
                'Welcome ${widget.userName}',
                style: TextStyle(
                  fontSize: 28,   
                )
              )
            ),
            Container(   
              padding: EdgeInsets.fromLTRB(10,60,10,10),
              child: RaisedButton(
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (context) => CreatePost());
                    Navigator.push(context, route);
                  },
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  child: Text('New Post'),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: () async {
                  await fetchNicknames().then((value){
                  nickNamesList=value['nicknames'].toList();
                });
                Route route = MaterialPageRoute(builder: (context) => NickNamesPage(nickNamesList));
                Navigator.push(context, route);
                },
                textColor: Colors.white,
                color: Colors.blueAccent,
                child: Text('See Nicknames'),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: () async {
                  await fetchHashTags().then((value) {
                    hashTagsList = value['hashtags'].toList();
                  });
                Route route = MaterialPageRoute(builder: (context) => HashTagsPage(hashTagsList));
                Navigator.push(context, route);
                },
                textColor: Colors.white,
                color: Colors.blueAccent,
                child: Text('See HashTags'),
              ),
            ),
          ]
        )
      )
    );
  }
}

Future<Map> fetchHashTags() async {
  final httpClient = new HttpClient();
  httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  final http = new IOClient(httpClient);
  final response = await http.get('https://bismarck.sdsu.edu/api/instapost-query/hashtags');
  return json.decode(response.body) as Map;
}

Future<Map> fetchNicknames() async {
  final httpClient = new HttpClient();
  httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  final http = new IOClient(httpClient);
  final response = await http.get('https://bismarck.sdsu.edu/api/instapost-query/nicknames');
  return json.decode(response.body) as Map;
}


