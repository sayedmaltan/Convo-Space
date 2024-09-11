import 'package:flutter/material.dart';
import 'package:iti_project/modules/call/resgister_page.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'constants.dart';



class CallPage extends StatelessWidget {
  String name;
  String email;
  String id;

  CallPage({required this.name,  required this.email, required this.id});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:
      appID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
      appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: email,
      userName: name,
      callID: id,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}