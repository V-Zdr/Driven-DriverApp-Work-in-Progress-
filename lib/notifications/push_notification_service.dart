// import 'package:drivers_app/global/global.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// class PushNotificationService{
//   final FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
//
//   Future initialize()async{
//     onMessage: FirebaseMessaging.onMessage;
//     onLaunch:FirebaseMessaging.onMessageOpenedApp;
//     onResume:FirebaseMessaging.onMessageOpenedApp;
//   }
//   Future<String?> getToken()async{
//     String? token = await firebaseMessaging.getToken();
//     DatabaseReference driversRef=FirebaseDatabase.instance.ref().child("drivers");
//     driversRef.child(currentFirebaseUser!.uid).child("token").set(token);
//     print("This is token ::");
//     print(token);
//     firebaseMessaging.subscribeToTopic("allDrivers");
//     firebaseMessaging.subscribeToTopic("allUsers");
//   }
// }