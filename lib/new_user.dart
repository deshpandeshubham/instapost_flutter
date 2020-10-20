import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';
import 'model/User.dart';

var firstNameController = new TextEditingController();
var lastNameController = new TextEditingController();
var nickNameController = new TextEditingController();
var emailController = new TextEditingController();
var passwordController = new TextEditingController();

final formKey = GlobalKey<FormState>();

class NewUser extends StatefulWidget {
  @override
  NewUserState createState() {
    return NewUserState();
  }
}

class NewUserState extends State<NewUser> {

  User userData = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'First Name cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Last Name cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: nickNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nick Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Nickname cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email cannot be empty!';
                    }
                    return null;
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
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('Sign Up'),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      userData.firstName = firstNameController.text.trim();
                      userData.lastName = lastNameController.text.trim();
                      userData.nickName = nickNameController.text.trim();
                      userData.email = emailController.text.trim();
                      userData.password = passwordController.text.trim();
                      createUser(userData);
                      Navigator.pop(context);
                    }
                  },
                )
              ),
            ],
          )
        )
      )
    );
  }
}

Future<http.Response> createUser(User user) {
  print(user.firstName+user.lastName+user.email+user.password+user.nickName);
  final ioc = new HttpClient();
  ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  final http = new IOClient(ioc);
  return http.post(
    'https://bismarck.sdsu.edu/api/instapost-upload/newuser',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "firstname": user.firstName,
      "lastname": user.lastName,
      "nickname": user.nickName,
      "email": user.email,
      "password": user.password
    }),
  );
}

