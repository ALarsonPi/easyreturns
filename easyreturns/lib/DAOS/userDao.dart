import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/User.dart';

class UserDao {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getUsers() {
    return usersCollection.snapshots();
    //return collection.orderBy('score', descending: true).snapshots();
  }

  Future<DocumentReference> addUser(User currUser) {
    return usersCollection.add(currUser.toJson());
  }

  // Future<int> findNumberOfScoresHigherThan(int currScore) async {
  //   int count = await collection
  //       .where('score', isGreaterThan: currScore)
  //       .orderBy('score', descending: true)
  //       .get()
  //       .then((value) => value.size);
  //   return count;
  // }

  void updateUser(User currUser) async {
    await usersCollection.doc(currUser.userID).update(currUser.toJson());
  }

  void deleteUser(User currUser) async {
    await usersCollection.doc(currUser.userID).delete();
  }
}
