import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iti_project/modules/messenger/chat_screen/main_chat.dart';
import 'package:iti_project/modules/messenger/login_and_register/login_shop_screen/login.dart';
import 'package:iti_project/shared/componants.dart';

import '../../../services/authentication/auth_service.dart';
import '../../../services/chat_services/chat_service.dart';



class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ChatService chatService = ChatService();
  AuthService authService = AuthService();
  File? _image;
  String? _downloadURL;
  final ImagePicker _picker = ImagePicker();
  Widget uploadOrCircular=Text('Save !',style: TextStyle(color: Colors.blue),);


  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> getProfile() async {
    // Reference to the document you want to retrieve
    DocumentReference documentReference = firestore.collection('Users').doc(AuthService().getCurrentUser()!.uid);

    // Fetch the document
    DocumentSnapshot documentSnapshot = await documentReference.get();

    // Access the specific field you want to retrieve
    if (documentSnapshot.exists) {
      String imageProfile = documentSnapshot.get('imageProfile');
      return imageProfile;// Access 'name' field
    }
    return "https://png.pngitem.com/pimgs/s/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png";
  }
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

      // Save the file to Firebase Storage
      await storageRef.putFile(_image!);

      // Get the download URL for the uploaded image
      String downloadURL = await storageRef.getDownloadURL();

      AuthService authService = AuthService();
      firestore.collection('Users').doc(authService.getCurrentUser()!.uid).update(
          {
            'imageProfile':downloadURL
          });
      setState(() {
        _downloadURL = downloadURL;
      });
      uploadOrCircular=Text('Save !',style: TextStyle(color: Colors.blue),);
      if(_downloadURL!=null) {
        defaultToast("Saved Succes", Colors.green);
        Navigator.pop(context);
      }
      setState(() {

      });
      print('Image uploaded and download URL: $_downloadURL');
    } catch (e) {
      uploadOrCircular=Text('Save !',style: TextStyle(color: Colors.blue),);
      defaultToast("Failed !", Colors.red);
      setState(() {

      });
      print('Error uploading image: $e');
    }
  }
  late String imageProfilee="https://png.pngitem.com/pimgs/s/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png";

   Future<String> getProfilePhoto() async {
    // Reference to the document you want to retrieve
    DocumentReference documentReference = firestore.collection('Users').doc(authService.getCurrentUser()!.uid);

    // Fetch the document
    DocumentSnapshot documentSnapshot = await documentReference.get();

    // Access the specific field you want to retrieve
    if (documentSnapshot.exists) {
      var imageProfile = documentSnapshot.get('imageProfile');
      // Access 'name' field
      return imageProfilee=imageProfile;
    }
    print("////////////////////////////////////${authService.getCurrentUser()!.email}");

    return imageProfilee;
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk${authService.getCurrentUser()!.email}");
    getProfilePhoto().then((onValue){
      imageProfilee=onValue;
      setState(() {

      });
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back)),
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
                    backgroundImage: NetworkImage(
                        imageProfilee
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.photo_library,color: Colors.blue,),
                        label: Text('Gallery',style: TextStyle(color: Colors.blue),),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera_alt,color: Colors.blue),
                        label: Text('Camera',style: TextStyle(color: Colors.blue),),
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
