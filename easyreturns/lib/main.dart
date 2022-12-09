import 'package:easyreturns/mainGlobal/FileTracker.dart';
import 'package:easyreturns/mainGlobal/Global.dart';
import 'package:easyreturns/screens/NewPickupScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'mainGlobal/AppRouter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

Future<void> main() async {
  // Setting the App as Vertical Only
  // Landscape is Disabled
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  List<bool> registerAndLoginStatus =
      await FileTracker.readRegisterAndLoginStatus();
  Global.isRegistered = registerAndLoginStatus[0];
  Global.isLoggedIn = registerAndLoginStatus[1];

  debugPrint("Is Registered: " + Global.isRegistered.toString());
  debugPrint("Is Logged in: " + Global.isLoggedIn.toString());

  // THIS SHOULD BE CHANGED
  Global.isLoggedIn = true;
  Global.isRegistered = true;

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }

  runApp(const AppRouter());
}
