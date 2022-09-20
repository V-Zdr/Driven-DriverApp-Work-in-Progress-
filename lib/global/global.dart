

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseAuth fAuth= FirebaseAuth.instance;
User? currentFirebaseUser;
User? userCurrentInfo;
User? firebaseUser;
StreamSubscription<Position>? homeTabPageStreamSubscription;