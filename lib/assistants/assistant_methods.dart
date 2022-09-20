import 'package:drivers_app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';

class AssistantMethods{
  static void retrieveHistoryInfo(){
    DatabaseReference driversRef=FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(firebaseUser!.uid).child("earnings").once().then((value) =>{
      if(value.snapshot.value != null){
        // String earnings = value.snapshot.value.toString();
      }
    });
  }
}