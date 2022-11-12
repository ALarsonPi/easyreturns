import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  //Blank User
  User({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.streetAddress,
    required this.aptNumber,
    required this.extraAddressInfo,
    required this.city,
    required this.zipCode,
  });

  User.blank() {
    username = "blank";
    password = "password";
    firstName = "firstname";
    lastName = "lastName";
    phoneNumber = "555-555-5555";
    aptNumber = "123";
    extraAddressInfo = "None";
    city = "city";
    zipCode = "zipCode";
  }

  late String? userID;

  late String username;
  late String password;

  late String firstName;
  late String lastName;
  late String phoneNumber;
  late String streetAddress;
  late String aptNumber;
  late String extraAddressInfo;
  late String city;
  late String zipCode;

  Map<String, dynamic> toJson() => _userToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _userFromJson(json);

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final newUser = User.fromJson(snapshot.data() as Map<String, dynamic>);
    newUser.userID = snapshot.reference.id;
    return newUser;
  }
}

User _userFromJson(Map<String, dynamic> json) {
  return User(
    username: json['username'] as String,
    password: json['password'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    phoneNumber: json['phoneNumber'] as String,
    streetAddress: json['streetAddress'] as String,
    aptNumber: json['aptNumber'] as String,
    extraAddressInfo: json['extraAddressInfo'] as String,
    city: json['city'],
    zipCode: json['zipCode'],
  );
}

Map<String, dynamic> _userToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'streetAddress': instance.streetAddress,
      'aptNumber': instance.aptNumber,
      'exraAddressInfo': instance.extraAddressInfo,
      'city': instance.city,
      'zipCode': instance.zipCode,
    };
