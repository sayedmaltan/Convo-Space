import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/modules/messenger/drower/settings.dart';

import '../../../services/authentication/auth_service.dart';

class Drower extends StatelessWidget {
  const Drower({super.key});
  void signOut(
      )
  {
    final authh=AuthService();
    authh.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
        ),
        body: Container(
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  size: 60,
                  color: Colors.white70,
                  Icons.message
                ),
                Column(
                  children: [
                    ListTile(
                      onTap: () {
                     Navigator.pop(context);
                      },
                      title: Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      leading:Icon(
                          Icons.home,
                        color: Colors.white70,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Settings();
                        },));
                      },
                      title: Text(
                          'Settings',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      leading:Icon(
                          Icons.settings,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  onTap: () {
                    signOut();
                  },
                  title: Text(
                      'Logout',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  leading:Icon(
                      Icons.logout,
                    color: Colors.white70,

                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
