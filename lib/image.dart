import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

class GetImage extends StatelessWidget {
  final String base64image;
  
  GetImage(this.base64image);

  Widget build(BuildContext context) {
    Uint8List decodedBytes = base64Decode(base64image);
    return Scaffold (
      appBar: new AppBar(title:  new Text("Image")),
      body: Container (
        child: new Image.memory(decodedBytes),
      ),
    );
  }
}