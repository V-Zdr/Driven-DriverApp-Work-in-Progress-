import 'package:drivers_app/authentication/login_screen.dart';
import 'package:drivers_app/global/global.dart';
import 'package:drivers_app/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  _StateProfileTabPage createState() => _StateProfileTabPage();
}

class _StateProfileTabPage extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Sign out."),
        onPressed: (){
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
        },
      ),
    );
  }
}
