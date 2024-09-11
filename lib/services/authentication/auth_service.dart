import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  final FirebaseFirestore fireStore=FirebaseFirestore.instance;
  // sign in
  Future<UserCredential> signInWithEmailAndPassword({required String email,required String password}) async {
      return await firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((onValue){
      //  Map<String,dynamic> user=fireStore.collection('Users').doc(onValue.user!.uid).get() as Map<String,dynamic>;
      // fireStore.collection("Users").doc(onValue.user!.uid).set({
      //   'uid':onValue.user!.uid,
      //   'email':email,
      //   'name':user['name'],
      // });
        return onValue;
    }).catchError((onError){
      print(onError.toString());
    });
  }

  User? getCurrentUser(){
    return firebaseAuth.currentUser;
  }

  Future<UserCredential> signUpWithEmailAndPassword({required String email,required String password,required String name}) async {
    return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((onValue){
      fireStore.collection("Users").doc(onValue.user!.uid).set({
        'uid':onValue.user!.uid,
        'email':email,
        'name':name,
        'story':'',
        'imageProfile':'https://png.pngitem.com/pimgs/s/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png'
      });
      return onValue;
    }).catchError((onError){
      print(onError.toString());
    });
  }

//   sign out
  Future<void> signOut() async {
  await firebaseAuth.signOut();
}
}