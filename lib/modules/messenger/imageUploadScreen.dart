import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iti_project/modules/messenger/chat_screen/main_chat.dart';
import 'package:iti_project/modules/messenger/login_and_register/login_shop_screen/login.dart';
import 'package:iti_project/shared/componants.dart';

import '../../services/chat_services/chat_service.dart';


class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  ChatService chatService=ChatService();
  File? _image;
  String? _downloadURL;
  final ImagePicker _picker = ImagePicker();
  Widget uploadOrCircular=Text('Upload !');

  // Function to pick image from gallery or camera

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image!.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to upload image to Firebase
  Future<void> _uploadImage() async {
    uploadOrCircular=CircularProgressIndicator();
    setState(() {

    });
    if (_image == null) return;

    try {
      // Create a reference to the Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final firestore = FirebaseFirestore.instance;

      // Upload the file to Firebase Storage
      await storageRef.putFile(_image!);

      // Get the download URL for the uploaded image
      String downloadURL = await storageRef.getDownloadURL();
      firestore.collection('userProfile').add({
        'name':'sayed',
        'imageLink':downloadURL
      });
      setState(() {
        _downloadURL = downloadURL;
      });
      uploadOrCircular=Text('Upload !');
      if(_downloadURL!=null) {
        defaultToast("Uploaded Succes", Colors.green);
        Navigator.pop(context);
      }
      setState(() {

      });
      print('Image uploaded and download URL: $_downloadURL');
    } catch (e) {
      uploadOrCircular=Text('Upload !');
      defaultToast("Failed !", Colors.red);
      setState(() {

      });
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _image != null
                ?
            CircleAvatar(
              radius: 68,
                backgroundImage: FileImage(_image!),
            )
                : CircleAvatar(
        radius: 68,
        backgroundImage: AssetImage(
            'assets/images/profile_image.png'),
      ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text('Gallery'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera_alt),
                  label: Text('Camera'),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadImage,
              child: uploadOrCircular,
            ),
            SizedBox(height: 16),
           if (_downloadURL == null)
                Text('No image uploaded yet.',
                style: TextStyle(
                  color: Colors.grey
                ),
                ),
          ],
        ),
      ),
    );
  }
}
