import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/users.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';


class FirebaseService{

static final CollectionReference userCollection = FirebaseFirestore.instance
    .collection('ShopAppUsers');
static UserCredential userCredential;

// Auth System
static Future create(String email1,String pass,BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email1,
        password: pass
    ).catchError((onError)=>Scaffold.of(context).showSnackBar(SnackBar(content: Text("$onError"))));

    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

static Future sign(String e,String pass,BuildContext context) async {
  try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: e,
        password: pass
    ).catchError((onError)=>Scaffold.of(context).showSnackBar(SnackBar(content: Text("You Don't Have Account "))));
      return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

static checkClientData(BuildContext context) async {
  await FirebaseDatabase.instance.reference().child("ShopAppUsers").once().then((DataSnapshot snapshot) {
    if(snapshot.value!=null)
      Navigator.pushNamed(context, LoginSuccessScreen.routeName);
    else
      Navigator.pushNamed(context, CompleteProfileScreen.routeName);
  });
}

static Future<void> SaveNewUserData(users user,BuildContext context) async{
  return await userCollection.doc(user.firstName+" "+user.lastName)
  .set({
    "firstName":user.firstName,
    "lastName":user.lastName,
    "phoneNumber":user.phoneNumber,
    "address":user.address
    }).catchError((onError)=>Scaffold.of(context).showSnackBar(SnackBar(content: Text("$onError"))))
      .then((value) => Navigator.pushNamed(context, OtpScreen.routeName));
}

Future getData() async {
  List itemlist = [];
  return await userCollection.get().then((value) => {
    value.docs.forEach((element) { itemlist.add(element.data);})
  });
}


}