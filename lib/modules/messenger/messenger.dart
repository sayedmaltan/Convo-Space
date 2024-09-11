import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/modules/messenger/drower/drower.dart';
import 'package:iti_project/modules/messenger/people_screen/peoble_screen.dart';
import 'package:iti_project/modules/messenger/stories_screen/stories_screen.dart';

import 'chat_screen/main_chat.dart';


class Messenger extends StatefulWidget {
  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int bottomNavIndex=0;
  List<Widget>  screensList=[
    MainChat(),
    PeopleScreen(),
    StoriesScreen(),
  ];
  List<String>  appBarString=[
    "Chats",
    "People",
    "Stories",
  ];
  List<IconData>  appBarIcon=[
   Icons.edit_rounded,
   Icons.perm_contact_cal_rounded,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leadingWidth: 65,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white24,
            radius: 20,
            child: IconButton(
              icon: Icon(Icons.menu,color: Colors.white,),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
        ),
        // leading: const Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 11),
        //   child: CircleAvatar(
        //     backgroundColor: Colors.white24,
        //     radius: 20,
        //     child: Icon(
        //       Icons.menu,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        title:  Text(
          appBarString[bottomNavIndex],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 29,
            fontWeight: FontWeight.w700,
            fontFamily: "jannah"
          ),
        ),

        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: false,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: bottomNavIndex,
        onTap: (value) {
          setState(() {
            bottomNavIndex=value;
          });
        },
        items: [
      BottomNavigationBarItem(
      label: "Chats",
      icon: Icon(Icons.chat_bubble),

      ),
      BottomNavigationBarItem(
            label: "People",
            icon: Icon(Icons.people),

          ),
      BottomNavigationBarItem(
            label: "Stories",
            icon: Icon(Icons.amp_stories),

          ),
    ]
      ),
      body:  screensList[bottomNavIndex],
drawer: Drower(
),

    );
  }
}
