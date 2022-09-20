import 'package:drivers_app/main.dart';
import 'package:drivers_app/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/authentication/signup_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _StateLoginScreen createState() => _StateLoginScreen();
}

class _StateLoginScreen extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm(){
    if(!emailTextEditingController.text.contains("@")){
      Fluttertoast.showToast(msg: "Email address is not valid");
    }
    else if(passwordTextEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: "Password must be at least 6 characters");
    }
    else{
      loginDriverNow();
    }
  }
  loginDriverNow()async{
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: "Processing...",);
        }
    );
    final User? firebaseUser=(
        await fAuth.signInWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim()
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error" + msg.toString());
        })
    ).user;

    if(firebaseUser!=null){
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).once().then((event){
        final snap=event.snapshot;
        if(snap!.value!=null){
          currentFirebaseUser=firebaseUser;
          Fluttertoast.showToast(msg: "Successful login.");
          Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
        }
      });
    }
    else{
      Navigator.pop(context);
      fAuth.signOut();
      Fluttertoast.showToast(msg: "Incorrect info.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo2.png"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Login as a driver.",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold)),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter Email",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  hintStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter Password",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  hintStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  validateForm();
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                child: const Text(
                  "Don't have an account? Sign up here.",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => SignUpScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
