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

  Future<User> findUserbyID(String userID) async {
    return (usersCollection.where('userID', isEqualTo: userID).get() as User);
  }

  void updateUser(User currUser) async {
    await usersCollection.doc(currUser.userID).update(currUser.toJson());
  }

  void deleteUser(User currUser) async {
    await usersCollection.doc(currUser.userID).delete();
  }
}
