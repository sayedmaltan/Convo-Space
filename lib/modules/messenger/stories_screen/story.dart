
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/chat_model.dart';


class Story extends StatefulWidget {

  Map userData;
  Story(this.userData);

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 30,
                color: Colors.white,
              ),
              onPressed:() {
                Navigator.pop(context);
              },
            ),
          ),
        ],
        backgroundColor: Colors.black,
        leadingWidth: 80,
        leading:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child:   CircleAvatar(
              backgroundImage: NetworkImage(widget.userData['imageProfile']),
            radius:20,
          ),
        ),
        title:  Text(
          widget.userData['name'],
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500
          ),
        ),
      ),
      body:Image(
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        image: NetworkImage(
            widget.userData['story']
        ),
      ),

    );
  }
}




