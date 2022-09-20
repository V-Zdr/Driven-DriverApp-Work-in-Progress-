import 'dart:async';

import 'package:drivers_app/global/global.dart';
import 'package:drivers_app/main.dart';
import 'package:drivers_app/notifications/push_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _StateHomeTabPage createState() => _StateHomeTabPage();
}

class _StateHomeTabPage extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;
  Position? currentPosition;
  var geoLocator=Geolocator();
  String driverStatusText = "Offline now - go Online";
  Color driverStatusColor = Colors.black;
  bool isDriverAvailable = false;
  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
  }


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void locatePosition()async{
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition=position;

    LatLng latLngPosition=LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition,zoom: 14);
    newGoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // String address = await AssistantMethods.searchCoordinateAddress(position,context);
    // print("This is your address: " + address);
  }

  void getCurrentDriverInfo()async{
    currentFirebaseUser=await FirebaseAuth.instance.currentUser;
    // PushNotificationService pushNotificationService=PushNotificationService();
    // pushNotificationService.initialize();
    // pushNotificationService.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller){
            _controllerGoogleMap.complete(controller);
            newGoogleMapController=controller;
            locatePosition();
          },
        ),
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),
        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(isDriverAvailable==false){
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();
                      setState(() {
                        driverStatusColor=Colors.green;
                        driverStatusText = "Online now";
                        isDriverAvailable=true;
                      });
                      Fluttertoast.showToast(msg: "You are online now.");
                    }
                    else{
                      makeDriverOfflineNow();
                      setState(() {
                        driverStatusColor=Colors.black;
                        driverStatusText = "Offline now - go Online";
                        isDriverAvailable=false;
                      });
                      Fluttertoast.showToast(msg: "You are offline now.");
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: driverStatusColor),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          driverStatusText!,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Icon(Icons.phone_android,color: Colors.white,size: 26.0,)
                      ],
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
      ],
    );
  }
  void makeDriverOnlineNow()async{
    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition=position;
    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition!.latitude, currentPosition!.longitude);
    rideRequestRef!.onValue.listen((event) { });
  }
  void makeDriverOfflineNow(){
    Geofire.removeLocation(currentFirebaseUser!.uid);
    rideRequestRef!.onDisconnect();
    rideRequestRef!.remove();
    rideRequestRef=null;
  }
  void getLocationLiveUpdates(){
    homeTabPageStreamSubscription=Geolocator.getPositionStream().listen((Position position) {
      currentPosition=position;
      if(isDriverAvailable==true){
        Geofire.setLocation(currentFirebaseUser!.uid, position!.latitude, position!.longitude);
      }
      LatLng latLng=LatLng(position!.latitude, position!.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
