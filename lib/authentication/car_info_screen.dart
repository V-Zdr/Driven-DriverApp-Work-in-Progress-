import 'package:drivers_app/global/global.dart';
import 'package:drivers_app/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({Key? key}) : super(key: key);

  @override
  _StateCarInfoScreen createState() => _StateCarInfoScreen();
}

class _StateCarInfoScreen extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
  TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypesList = ["uber-x", "uber-go", "bike"];
  String? selectedCarType;

  saveCarInfo(){
    Map driversCarInfoMap = {
      "car_color": carColorTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "type": selectedCarType,
    };
    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driversCarInfoMap);
    Fluttertoast.showToast(msg: "Car details have been saved");
    Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));

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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo2.png"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Write Car Details.",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold)),
              TextField(
                controller: carModelTextEditingController,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                  labelText: "Car Model",
                  hintText: "Enter Car Model",
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
                controller: carNumberTextEditingController,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                  labelText: "Car Number",
                  hintText: "Enter Car Number",
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
                controller: carColorTextEditingController,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                  labelText: "Car Color",
                  hintText: "Enter Car Color",
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
              const SizedBox(height: 20),
              DropdownButton(
                hint: const Text(
                  "Please choose vehicle type",
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
                value: selectedCarType,
                onChanged: (newValue) {
                  setState(() {
                    selectedCarType = newValue.toString();
                  });
                },
                items: carTypesList.map((car) {
                  return DropdownMenuItem(
                    child: Text(
                      car,
                      style: TextStyle(color: Colors.blue),
                    ),
                    value: car,
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(carColorTextEditingController.text.isNotEmpty &&
                        carModelTextEditingController.text.isNotEmpty &&
                        carNumberTextEditingController.text.isNotEmpty &&
                    selectedCarType!=null){
                      saveCarInfo();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Icon(Icons.person,color: Colors.white,size: 26.0,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
