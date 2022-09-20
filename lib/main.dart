import 'package:drivers_app/authentication/login_screen.dart';
import 'package:drivers_app/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/splashScreen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentFirebaseUser=FirebaseAuth.instance.currentUser;
  runApp(MyApp(
    child: MaterialApp(
      title: 'Drivers App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser==null ? LoginScreen() : MySplashScreen(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}

class MyApp extends StatefulWidget {
  final Widget? child;

  MyApp({this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

// DatabaseReference usersRef=FirebaseDatabase.instance.ref().child("users");
// DatabaseReference driversRef=FirebaseDatabase.instance.ref().child("drivers");
DatabaseReference? rideRequestRef=FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRide");

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child!);

  }
}
