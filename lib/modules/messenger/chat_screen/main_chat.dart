
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iti_project/services/authentication/auth_service.dart';
import 'package:iti_project/services/chat_services/chat_service.dart';
import 'package:iti_project/shared/constants.dart';

import 'conversation_chat.dart';

class MainChat extends StatefulWidget {
  @override
  State<MainChat> createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {
  ChatService chatService = ChatService();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatService.getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError)
          return Text("Error");

        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());

        return Column(
          children: [
            const SizedBox(
              height: 13,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: Container(
                height: 43,
                width: double.infinity,
                child: const Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.search,
                      size: 23,
                      color: Colors.white70,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(25),
                    color: Colors.white24),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  children: [
                    for (int i = 0; i < snapshot.data!.length; i++)
                      if (snapshot.data![i]['email'] !=
                          authService.getCurrentUser()!.email)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: InkWell(
                            radius: 20,
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConversationChat(
                                      userData: snapshot.data![i],
                                      chatMode: modelsList[i],
                                      receiverEmail: snapshot.data![i]['email'],
                                      receiverId: snapshot.data![i]['uid'],
                                    ),
                                  ));
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(snapshot.data![i]['imageProfile']),
                                      radius: 38,
                                    ),
                                    if (modelsList[i].isActive)
                                      const CircleAvatar(
                                        backgroundColor: Colors.black,
                                        radius: 9,
                                      ),
                                    if (modelsList[i].isActive)
                                      const CircleAvatar(
                                        backgroundColor: Colors.green,
                                        radius: 7,
                                      ),
                                  ],
                                  alignment: AlignmentDirectional.bottomEnd,
                                ),
                                Text(
                                  // hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee175
                                  snapshot.data![i]['name'].split(" ")[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < snapshot.data!.length; i++)
                      if (snapshot.data![i]['email'] !=
                          authService.getCurrentUser()!.email)

                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConversationChat(
                                          chatMode: modelsList[i],
                                          userData: snapshot.data![i],
                                          receiverEmail: snapshot.data![i]
                                              ['email'],
                                          receiverId: snapshot.data![i]['uid'],
                                        )));
                          },
                          leading: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                      NetworkImage(snapshot.data![i]['imageProfile']),
                                radius: 25,
                              ),
                              if (modelsList[i].isActive)
                                const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 9,
                                ),
                              if (modelsList[i].isActive)
                                const CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 7,
                                ),
                            ],
                          ),
                          title: Text(
                            // hereeeeeeeeeeeeeeeeeeeeeeeeeee115
                            snapshot.data![i]['name']??"",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: buildLastMessage(snapshot, i),
                          // subtitle: Text(
                          //   modelsList[i]
                          //       .message[modelsList[i].message.length - 1],
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          trailing: buildLastTime(snapshot, i)
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

  Widget buildLastTime(snapshot, i) {
    String senderId = authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: chatService.getMessage(
            userId: snapshot.data![i]['uid'], otherUserId: senderId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return
            Text("Error");
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          {
            Map<String, dynamic> dataa= {};
            if(snapshot.data!.docs.length-1>=0) {
              dataa = snapshot.data!.docs[snapshot.data!.docs.length-1]
                  .data() as Map<String, dynamic>;
            }
            String lastTimeWithDate="";
            String dateOnly="";
            String lastTime="";
            DateTime chatDate=DateTime.now();
            DateTime today=chatDate;
            if(dataa['timestamp']!=null) {
              DateTime dateTime = dataa['timestamp'].toDate();
              DateFormat dateFormat = DateFormat('yy/M/d hh:mm a');
              DateFormat dateFormat2 = DateFormat('hh:mm a');
              DateFormat dateFormat3 = DateFormat('M/d/yy');
               lastTimeWithDate = dateFormat.format(dateTime);
               lastTime=dateFormat2.format(dateTime);
              dateOnly=dateFormat3.format(dateTime);
               today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
               chatDate = DateTime(dateTime.year,dateTime.month,dateTime.day);
            }
            if (chatDate.isBefore(today)) {
              return Text(dateOnly);
            } else {
              return Text(lastTime);
            }

          }
        });
  }

  Widget buildLastMessage(snapshot, i) {
    String senderId = authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: chatService.getMessage(
            userId: snapshot.data![i]['uid'], otherUserId: senderId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return
            Text("Error");
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          {
            Map<String, dynamic> dataa= {};
            if(snapshot.data!.docs.length-1>=0) {
              dataa = snapshot.data!.docs[snapshot.data!.docs.length-1]
                .data() as Map<String, dynamic>;
            }
            print("hiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
            return Text(dataa['message']??"");
          }
        });
  }
}

