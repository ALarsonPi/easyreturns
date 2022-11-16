import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyreturns/models/PickupRequest.dart';
import 'package:flutter/cupertino.dart';

class PickupRequestDao {
  final CollectionReference pickupRequestCollection =
      FirebaseFirestore.instance.collection('pickupRequests');

  Stream<QuerySnapshot> getPickupRequestsStream() {
    return pickupRequestCollection.snapshots();
  }

  Stream<List<PickupRequest>> streamPickupRequestsList() {
    var thing = pickupRequestCollection.snapshots().map((list) =>
        list.docs.map((doc) => PickupRequest.fromSnapshot(doc)).toList());
    return thing;
  }

  Future<DocumentReference> addPickupRequest(PickupRequest currPickupRequest) {
    return pickupRequestCollection.add(currPickupRequest.toJson());
  }

  // Future<int> findNumberOfScoresHigherThan(int currScore) async {
  //   int count = await collection
  //       .where('score', isGreaterThan: currScore)
  //       .orderBy('score', descending: true)
  //       .get()
  //       .then((value) => value.size);
  //   return count;
  // }

  void updateUser(PickupRequest currPickupRequest) async {
    await pickupRequestCollection
        .doc(currPickupRequest.pickupRequestID)
        .update(currPickupRequest.toJson());
  }

  void deleteUser(PickupRequest currPickupRequest) async {
    await pickupRequestCollection
        .doc(currPickupRequest.pickupRequestID)
        .delete();
  }
}
