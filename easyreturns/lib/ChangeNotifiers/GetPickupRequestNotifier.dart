import 'package:easyreturns/models/PickupRequest.dart';
import 'package:flutter/cupertino.dart';

class GetPickupRequestNotifier extends ChangeNotifier {
  late List<PickupRequest> pickupRequests = List.empty(growable: true);
}
