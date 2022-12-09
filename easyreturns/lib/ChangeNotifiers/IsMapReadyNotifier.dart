import 'package:flutter/material.dart';

class IsMapReadyNotifier extends ChangeNotifier {
  late bool hasLocationPermission = false;
  late bool isMapReady = false;

  setHasLocationPermission(bool locationPermission) {
    hasLocationPermission = locationPermission;
    notifyListeners();
  }

  setIsMapReady(bool isReady) {
    isMapReady = isReady;
    notifyListeners();
  }
}
