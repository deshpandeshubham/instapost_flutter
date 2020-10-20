import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:instapost/nickname_posts.dart';

List<dynamic> postIdsList = [];

class NickNamesPage extends StatelessWidget {
  final List<dynamic> nickNamesList;

  NickNamesPage(this.nickNamesList);
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text("Nicknames"),  
      ),  
      body: ListView.builder(
        itemCount: nickNamesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            margin: EdgeInsets.all(2),
            child: Center(
              child: tappableText('${nickNamesList[index]}', context)
            ),
          );
        } 
      )
    );  
  } 

  Widget tappableText(String nickName, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await fetchPostIdsForNickName(nickName).then((value) {
          postIdsList = value['ids'].toList();
        });
        Route route = MaterialPageRoute(builder: (context) => NickNamePosts(postIdsList));
        Navigator.push(context, route);
      },
      child: Text(
        nickName,
        style: TextStyle(fontSize: 20, color: Colors.blue),
      ),
    );
  } 
}

Future<Map> fetchPostIdsForNickName(String nickName) async {
  print(nickName);
  final httpClient = new HttpClient();
  httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  final http = new IOClient(httpClient);
  final response = await http.get('https://bismarck.sdsu.edu/api/instapost-query/nickname-post-ids?nickname=$nickName');
  print(response.body);
  return json.decode(response.body) as Map;
}