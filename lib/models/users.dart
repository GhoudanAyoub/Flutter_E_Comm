import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';

class users{
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;

  users({@required this.firstName, @required this.lastName, @required this.phoneNumber, @required this.address});

  static void SaveNewUserData(users user,BuildContext context) {
    FirebaseFirestore.instance
        .collection('ShopAppUsers')
        .add({"user":user})
        .whenComplete(() => Navigator.pushNamed(context, OtpScreen.routeName));
  }
  static void createRecord(users user){
    FirebaseDatabase.instance.reference().child("ShopAppUsers").set(user);
  }
  void getData(){
    FirebaseDatabase.instance.reference().once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  void updateData(){
    FirebaseDatabase.instance.reference().child('1').update({
      'description': 'J2EE complete Reference'
    });
  }

  void deleteData(){
    FirebaseDatabase.instance.reference().child('1').remove();
  }
}