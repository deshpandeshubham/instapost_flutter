import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:instapost/nickname_posts.dart';
import 'package:instapost/post_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'model/PostDetails.dart';

var commentController = new TextEditingController();

class AddImage extends StatefulWidget {
  final int postId;
  PostDetails postDetails;
  AddImage(this.postId);
  @override
  AddImageState createState() => AddImageState(this.postId);
}

class AddImageState extends State<AddImage> {
  PostDetails postDetails;
  final int postId;
  AddImageState(this.postId);
  File imageFile;
  final picker = ImagePicker();
  PostDetails postData;
  Future getImage(String source) async {
    PickedFile pickedFile;
    if (source == "click") {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  String comment = "1";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Upload an image")),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              child: Text(
                "Add image to the post",
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
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: imageFile == null
                  ? Text('No image selected.')
                  : Image.file(imageFile),
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
                    child: Icon(Icons.add_a_photo),
                    onPressed: () {
                      getImage("click");
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
                    child: Icon(Icons.add),
                    onPressed: () {
                      getImage("gallery");
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
                    child: Text("Upload"),
                    onPressed: () async {
                      Map response = await uploadImage(postId.toString(), imageFile);
                      if(response['result'].toString() == "success") {
                        var x= await NickNamePosts.fetchPostDetails(postId.toString()).then((value) =>{
                          postDetails=PostDetails.fromJson(value['post']),
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsPage(postDetails)));
                      }
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
                    child: Text("Skip"),
                    onPressed: () async {
                      await NickNamePosts.fetchPostDetails(postId.toString()).then((value) => {
                        postDetails=PostDetails.fromJson(value['post']),
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsPage(postDetails)));
                    }
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Map> uploadImage(String postId, File image) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool trustSelfSigned = true;
  HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  IOClient ioClient = new IOClient(httpClient);
  final response = await ioClient.post(
      'https://bismarck.sdsu.edu/api/instapost-upload/image',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': prefs.getString("email"),
        'password': prefs.getString("password"),
        'image': base64Encode(image.readAsBytesSync()),
        'post-id': int.parse(postId),
      }));
  return json.decode(response.body) as Map;
}


