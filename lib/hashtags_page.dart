import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:instapost/nickname_posts.dart';

class HashTagsPage extends StatelessWidget {
  List<dynamic> hashTagsList;

  HashTagsPage(this.hashTagsList);
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text("HashTags"),  
      ),  
      body: ListView.builder(
        itemCount: hashTagsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            margin: EdgeInsets.all(2),
            child: Center(
              child: tappableText('${hashTagsList[index]}', context)
            ),
          );
        } 
      )
    );  
  }
              
  Widget tappableText(String hashTag, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await fetchPostIdsForHashTag(hashTag).then((value) {
          hashTagsList = value['ids'].toList();
        });
        Route route = MaterialPageRoute(builder: (context) => NickNamePosts(hashTagsList));
        Navigator.push(context, route);
      },
      child: Text(
        hashTag, 
        style: TextStyle(fontSize: 20, color: Colors.blue)
      ),
    );
  }  
}

Future<Map> fetchPostIdsForHashTag(String hashTag) async {
  hashTag = hashTag.replaceAll('#', '%23');
  final httpClient = new HttpClient();
  httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  final http = new IOClient(httpClient);
  final response = await http.get('https://bismarck.sdsu.edu/api/instapost-query/hashtags-post-ids?hashtag=$hashTag');
  return json.decode(response.body) as Map;
}