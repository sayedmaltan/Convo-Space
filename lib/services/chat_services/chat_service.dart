import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:iti_project/models/message.dart';
import 'package:iti_project/services/authentication/auth_service.dart';

class ChatService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(
      {required String receiverId, required String message}) async {
    final String currentUserId = firebaseAuth.currentUser!.uid;
    final String? currentUserEmail = firebaseAuth.currentUser!.email;
    final Timestamp timesTamp = Timestamp.now();
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail ?? "",
        receiverId: receiverId,
        message: message,
        timestamp: timesTamp);
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    await firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("message")
        .add(newMessage.toMap());
  }
  Future<void> uploadProfilePhoto(
      {required image}) async {
    final String currentUserId = firebaseAuth.currentUser!.uid;
    final String? currentUserEmail = firebaseAuth.currentUser!.email;
    final Timestamp timesTamp = Timestamp.now();
    await firestore
        .collection("chat_rooms")
        .doc(currentUserId)
        .set({
      'profileImage' :image
    });
  }

  Stream<QuerySnapshot> getMessage(
      {required String userId, required otherUserId}) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("message").orderBy("timestamp",descending: false).snapshots();
  }
}
