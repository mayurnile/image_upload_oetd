import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String serverEndPoint = "https://9c06979d.ngrok.io";

  File file;

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
    // file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void _upload() async {
    if (file == null) return;

    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;

    http.post(serverEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Uploader'),
      ),
      body: Column(
        children: <Widget>[
          file == null ? Text('No Image Selected') : Image.file(file),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: _choose,
                child: Text('Choose Image'),
              ),
              SizedBox(width: 10.0),
              RaisedButton(
                onPressed: _upload,
                child: Text('Upload Image'),
              )
            ],
          ),
          SizedBox(height: 22.0),
        ],
      ),
    );
  }
}
