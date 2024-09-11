import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iti_project/services/authentication/auth_service.dart';
import 'package:iti_project/services/chat_services/chat_service.dart';
import '../../../models/chat_model.dart';
import '../../call/video_call.dart';
class ConversationChat extends StatefulWidget {
  bool isActive=true;
  ChatModel chatMode;
  final String receiverEmail;
  final String receiverId;
  Map userData;
  ChatService chatService=ChatService();
  AuthService authService = AuthService();
  var control=TextEditingController();
  getRoomId(){
    List<String> ids = [authService.getCurrentUser()!.uid, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return chatRoomId;
  }
  Future<void> sendMessage() async {
    if(control.text.isNotEmpty)
      {
        await chatService.sendMessage(receiverId: receiverId, message: control.text);
        print("fffffffffffffffffffffffffffffffffffffffffff");
        control.clear();
      }
  }

  ConversationChat({required this.chatMode,required this.receiverEmail, required this.receiverId,required this.userData});

  @override
  State<ConversationChat> createState() => _ConversationChatState();
}

class _ConversationChatState extends State<ConversationChat> {
  AuthService auth=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return CallPage(
                        email:widget.userData['email'].toString(),
                        name:widget.userData['name'].toString(),
                        id:widget.getRoomId(),
                      );
                    }));
              },
              icon: Icon(
                Icons.videocam_rounded,
                size: 33,
                color: Colors.deepPurpleAccent,
              )

            ),
          ),
        ],
        backgroundColor: Colors.black,
        leadingWidth: 124,
        leading:  Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context); },
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.deepPurpleAccent,
                )),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child:   Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userData['imageProfile']),
                    radius:20,
                  ),
                  if(widget.chatMode.isActive)
                    const CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 7,
                    ),
                  if(widget.chatMode.isActive)
                    const CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 5,
                    ),
                ],
              ),
            ),
          ],
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
      body: Column(
        children: [
          buildMessageList(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              style: TextStyle(
                color: Colors.white,
              ),
              keyboardType: TextInputType.text,
              controller: widget.control,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      widget.sendMessage();
                        setState(() {});
                      widget.control.text = "";
                    },
                    icon:Icon(Icons.send)),
                hintText: 'Type a message',
                labelStyle: TextStyle(
                  color: Colors.white
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.white24
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildMessageList(){
    String senderId=widget.authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: widget.chatService.getMessage(userId: widget.receiverId, otherUserId: senderId),
      builder: (context, snapshot) {
        if(snapshot.hasError)
          return Text("Error");
        if(snapshot.connectionState==ConnectionState.waiting)
          return CircularProgressIndicator();
        return Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Map<String,dynamic> dataa=snapshot.data!.docs[index].data() as Map<String,dynamic>;
                return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(widget.chatMode.date[index],
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //           color: Colors.white60,
                  //           fontSize: 15
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Center(child: buildTime(index)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if(dataa['senderId']!=senderId)
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(widget.userData['imageProfile']),
                              radius:20,
                            ),
                            if(widget.chatMode.isActive)
                              const CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 7,
                              ),
                            if(widget.chatMode.isActive)
                              const CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 5,
                              ),
                          ],
                          alignment: AlignmentDirectional.bottomEnd,
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: BubbleSpecialThree(
                            isSender:dataa['senderId']==senderId?true:false,
                            sent:dataa['senderId']==senderId?true:false ,
                            text: dataa['message'],
                            color:dataa['senderId']==senderId?Colors.deepPurple: Colors.white24,
                            tail: false,
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              );
              },
              itemCount:        snapshot.data!.docs.length
          ),
        );
      },
    );
  }
  Widget buildTime(index) {
    String senderId=widget.authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: widget.chatService.getMessage(userId: widget.receiverId, otherUserId: senderId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return
            Text("Error");
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          {
            Map<String, dynamic> dataa= {};
            if(snapshot.data!.docs.length-1>=0) {
              dataa = snapshot.data!.docs[index]
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
              return Text("$dateOnly AT $lastTime",style: TextStyle(color: Colors.white30),);
            } else {
              return Text(lastTime,style: TextStyle(color: Colors.white30));
            }

          }
        });
  }


}
