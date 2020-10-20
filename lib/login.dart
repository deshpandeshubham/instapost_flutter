import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:instapost/model/Post.dart';
import 'package:flutter/material.dart';
import 'package:instapost/new_user.dart';
import 'package:instapost/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

var userNameController = new TextEditingController();
var passwordController = new TextEditingController();

final formKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  saveUserData() async {
    String email = userNameController.text;
    String password = passwordController.text;
    saveData(email, password);
  }
  //SharedPref sharedPref = SharedPref();
  Post userData = Post();

  Future<Map> authenticate(String email, String password) async {
    final ioc = new HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    final response = await http.get('https://bismarck.sdsu.edu/api/instapost-query/authenticate?email=$email&password=$password');
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map;
    } else {
      throw Exception('Login UnSuccessful');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'InstaPost',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
              )
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'UserName cannot be empty!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    userData.email = value;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Password cannot be empty!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    userData.password = value;
                  });
                },
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Login'),
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    var user=authenticate(userData.email,userData.password);
                    user.then((value) => {
                      if(value['result'].toString()=="true") {
                        //sharedPref.save("postdata", userData),
                        saveUserData(),
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userNameController.text)))
                        }
                      }
                    );
                  }
                },
              )
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Text('New User?'),
                  FlatButton(
                    textColor: Colors.blue,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (context) => NewUser());
                      Navigator.push(context, route);
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
            ))
          ],
        )
      )
    );
  }
}

Future<bool> saveData(String email, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("email", email);
  prefs.setString("password", password);
  return prefs.commit();
}