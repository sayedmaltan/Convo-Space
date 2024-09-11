import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iti_project/modules/messenger/stories_screen/story.dart';
import '../../../models/chat_model.dart';
import '../../../services/authentication/auth_service.dart';
import '../../../services/chat_services/chat_service.dart';
import '../../../shared/componants.dart';
import '../../../shared/constants.dart';

class StoriesScreen extends StatefulWidget {
  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  bool first = true;
  ChatService chatService = ChatService();
  AuthService authService = AuthService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  File? _image;
  String? _downloadURL;
  final ImagePicker _picker = ImagePicker();
  Widget uploadOrCircular = Text('Upload !');
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImage();
        print(_image!.path);


      } else {
        print('No image selected.');
      }
    });

  }

  // Function to upload image to Firebase
  Future<void> _uploadImage() async {
    uploadOrCircular = CircularProgressIndicator();
    setState(() {});
    if (_image == null) return;
    try {
      // Create a reference to the Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('uploadsStory/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final firestore = FirebaseFirestore.instance;

      // Upload the file to Firebase Storage
      await storageRef.putFile(_image!);

      // Get the download URL for the uploaded image
      String downloadURL = await storageRef.getDownloadURL();
      firestore
          .collection('Users')
          .doc(authService.getCurrentUser()!.uid)
          .update({'story': downloadURL});
      setState(() {
        _downloadURL = downloadURL;
      });
      uploadOrCircular = Text('Upload !');
      if (_downloadURL != null) {
        defaultToast("Uploaded Succes", Colors.green);
        getProfilePhotoAndStories().then((onValue) {
          users = onValue;
          print(users);
          setState(() {});
        });
      }

      setState(() {});
      print('Image uploaded and download URL: $_downloadURL');
    } catch (e) {
      uploadOrCircular = Text('Upload !');
      defaultToast("Failed !", Colors.red);
      setState(() {});
      print('Error uploading image: $e');
    }
  }

  late String imageProfilee =
      "https://png.pngitem.com/pimgs/s/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png";

  Future<List<Map>> getProfilePhotoAndStories() async {
    DocumentReference documentReference =
        firestore.collection('Users').doc(authService.getCurrentUser()!.uid);
    QuerySnapshot querySnapshot = await firestore.collection('Users').get();
    List<Map> users = [];
    querySnapshot.docs.map((doc) {
      Map<String, dynamic> oneUser;
      oneUser = doc.data() as Map<String, dynamic>;
      if (oneUser['email'] == authService.getCurrentUser()!.email) {
        imageProfilee = oneUser['imageProfile'];
        if(oneUser['story'].toString()=='https://png.pngitem.com/pimgs/s/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png')
        users.add({
          'imageProfile': oneUser['imageProfile'],
          'name': oneUser['name'],
          'story': oneUser['imageProfile']
        });
        else
          users.add({
            'imageProfile': oneUser['imageProfile'],
            'name': oneUser['name'],
            'story': oneUser['story']
          });
      }
      setState(() {});
      return oneUser;
    }).toList();
    querySnapshot.docs.map((doc) {
      Map<String, dynamic> oneUser;
      oneUser = doc.data() as Map<String, dynamic>;
      if (oneUser['email'] != authService.getCurrentUser()!.email &&
          oneUser['story'] != 'https://png.pngitem.com/pimgs/s/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png'&& oneUser['story'].toString().isNotEmpty) {
        users.add({
          'imageProfile': oneUser['imageProfile'],
          'name': oneUser['name'],
          'story': oneUser['story']
        });
      }
      setState(() {});
      return oneUser;
    }).toList();

    DocumentSnapshot documentSnapshot = await documentReference.get();

    // Access the specific field you want to retrieve
    if (documentSnapshot.exists) {
      var imageProfile = documentSnapshot.get('imageProfile');
      // Access 'name' field
      imageProfilee = imageProfile;
    }
    print(
        "////////////////////////////////////${authService.getCurrentUser()!.email}");

    return users;
  }

  Future<void> _showAwesomeDialog() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      btnCancelColor: Colors.orange,
      animType: AnimType.bottomSlide,
      title: 'Choose an option',
      desc: 'Select from where you want to pick the image',
      btnCancelOnPress: () {},
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Pick from Gallery'),
            onTap: () {
              _pickImage(ImageSource.gallery);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take a Picture'),
            onTap: () {
              _pickImage(ImageSource.camera);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    )..show();
  }

  List users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfilePhotoAndStories().then((onValue) {
      users = onValue;
      print(users);
      setState(() {});
    });
    setState(() {});
  }

  late ChatModel model;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("Error");

        // loading

        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        return Container(
            color: Colors.black,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 11,
                mainAxisSpacing: 11,
                childAspectRatio: .9 / 1,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                 {
                  return InkWell(
                    onTap: () {
                      if (index == 0)
                        _showAwesomeDialog();
                      else
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Story(users[index]),
                            ));
                    },
                    child:
                    (index ==0)
                        ?  Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10)),
                            child: Container(
                              height: 350,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[200],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: AlignmentDirectional.bottomStart,
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(users[0]['story']),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    height: 320,
                                    left: 15,
                                    child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.1),
                                            Colors.black.withOpacity(0.5)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Text(
                                          "Add to story",
                                          style: TextStyle(
                                              fontFamily: "jannah",
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        :
                      Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(10)),
                                child: Container(
                                  height: 350,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[200],
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomStart,
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                  users[index]['story']),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          alignment:
                                              AlignmentDirectional.bottomStart,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.1),
                                                Colors.black.withOpacity(0.5)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              users[index]['name'],
                                              style: TextStyle(
                                                  fontFamily: "jannah",
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            );
                };
              },
            ));
      },
    );
  }


}


