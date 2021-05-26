import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _scanning = false;
  String _extractText = '';
  File _pickedImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _extractText = await TesseractOcr.extractText(pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text('Tesseract OCR'),
      ),
      body: ListView(
        children: [
          _pickedImage == null
              ? Container(
            height: 300,
            color: Colors.grey[300],
            child: Icon(
              Icons.image,
              size: 100,
            ),
          )
              : Container(
            height: 300,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: FileImage(null),
                  fit: BoxFit.fill,
                )),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton(
              color: Colors.green,
              child: Text(
                'Pick Image with text',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                setState(() {
                  _scanning = true;
                });
                await getImage();
                setState(() {
                  _scanning = false;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          _scanning
              ? Center(child: CircularProgressIndicator())
              : Icon(
            Icons.done,
            size: 40,
            color: Colors.green,
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _extractText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
