import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String serverEndPoint = "https://cacb6553.ngrok.io/api/test";

  File file;

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
    // file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void _upload() async {
    if (file == null) return;
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse(serverEndPoint));

    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("image", file.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
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
