import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/services/authentication/auth_service.dart';
import 'package:iti_project/services/chat_services/chat_service.dart';

import '../../../shared/constants.dart';
import '../chat_screen/conversation_chat.dart';

class PeopleScreen extends StatelessWidget {
  ChatService chatService =ChatService();
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:chatService.getUserStream() ,
      builder: (context, snapshot) {
        // error
        if(snapshot.hasError)
          return Text("Error");


        // loading

        if(snapshot.connectionState==ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());

// return
        return Column(
          children: [
            const SizedBox(height: 13,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for(int i=0;i<snapshot.data!.length;i++)
                      if(snapshot.data![i]['email']!=authService.getCurrentUser()!.email)
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ConversationChat(
                                    chatMode: modelsList[i],
                                    userData: snapshot.data![i],
                                    receiverEmail: snapshot.data![i]['email'],
                                    receiverId: snapshot.data![i]['uid'],
                                  )));
                            },
                            leading:  Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data![i]['imageProfile']),
                                  radius: 25,
                                ),
                                if(modelsList[i].isActive)
                                  const CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 9,
                                  ),
                                if(modelsList[i].isActive)
                                  const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    radius: 7,
                                  ),
                              ],
                            ),
                            title: Text(
                              snapshot.data![i]['name'],
                              style:  TextStyle(
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
