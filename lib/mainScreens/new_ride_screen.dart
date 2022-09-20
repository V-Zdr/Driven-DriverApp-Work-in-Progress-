import 'package:flutter/material.dart';

class NewRideScreen extends StatefulWidget {
  const NewRideScreen({Key? key}) : super(key: key);

  @override
  State<NewRideScreen> createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Ride"
        ),
      ),
      body: Center(
        child: Text("New Ride Page"),
      ),
    );
  }
}
