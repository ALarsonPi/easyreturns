import 'package:easyreturns/models/PickupRequest.dart';
import 'package:flutter/material.dart';

import '../mainGlobal/Global.dart';

class RequestMapDetailsNotifier extends ChangeNotifier {
  String fullAddress = "Address";
  String nameOfCustomer = "Name of Customer";
  String phoneNumOfCustomer = "(555)-555-5555";
  String dayAndTimeOfPickup = "Mon, 9 am - 12 noon";
  String packages = "Shampoo Bottle (default)";

  void setNewRequestAsCurrent(PickupRequest pickup) {
    fullAddress =
        "${pickup.streetAddress}, ${pickup.city}, ${(pickup.zipCode.isNotEmpty) ? pickup.zipCode : ''}";
    nameOfCustomer = "${pickup.firstName} ${pickup.lastName}";
    phoneNumOfCustomer = pickup.phoneNumber;
    dayAndTimeOfPickup = "${pickup.dayOfPickup} ${pickup.timeFrameOfPickup}";

    packages = "";
    packages += pickup.packageDescription1;
    List<String> additionalDescriptions = List.empty(growable: true);
    additionalDescriptions.add(pickup.packageDescription2);
    additionalDescriptions.add(pickup.packageDescription3);
    additionalDescriptions.add(pickup.packageDescription4);
    for (int i = 0; i < Global.numPackagesAllowed - 1; i++) {
      if (additionalDescriptions.elementAt(i) != "blank") {
        packages += "\n${additionalDescriptions.elementAt(i)}";
      }
    }

    notifyListeners();
  }
}
