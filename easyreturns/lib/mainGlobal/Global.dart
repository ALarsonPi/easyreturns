import 'package:flutter_device_type/flutter_device_type.dart';

class Global {
  static bool isRegistered = false;
  static bool isLoggedIn = false;

  static int numPackagesAllowed = 4;

  static bool isAndroid = Device.get().isAndroid;
  static double screenHeight = Device.screenHeight;
}
