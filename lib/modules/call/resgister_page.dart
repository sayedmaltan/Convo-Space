


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/modules/call/video_call.dart';



class Registerpage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Join Video Call",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              SizedBox(
                height: 15,
              ),
              _buildTextFile(
                  controller: nameController,
                  labelText: "Name",
                  icon: Icons.person),
              SizedBox(
                height: 15,
              ),
              _buildTextFile(
                  controller: usernameController,
                  labelText: "UserName",
                  icon: Icons.person_2_outlined),
              SizedBox(
                height: 15,
              ),
              _buildTextFile(
                  controller: idController,
                  labelText: "VideoCallID",
                  icon: Icons.video_call),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return CallPage(
                            email: usernameController.text,
                            name: nameController.text,
                            id: idController.text,
                          );
                        }));
                  },
                  child: Text("Join"))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFile({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.blueAccent,
            ),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.blueAccent),
            filled: true,
            fillColor: Colors.blue[50],
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.blueAccent),
            )));
  }
}