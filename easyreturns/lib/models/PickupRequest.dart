import 'package:cloud_firestore/cloud_firestore.dart';

class PickupRequest {
  late String? pickupRequestID;
  late String? userID;
  late String? driverID;

  late String firstName;
  late String lastName;
  late String phoneNumber;

  late String packageDescription1;
  late String QRcode1;
  late String packageDescription2;
  late String QRcode2;
  late String packageDescription3;
  late String QRcode3;
  late String packageDescription4;
  late String QRcode4;

  late String dayOfPickup;
  late String timeFrameOfPickup;

  late String streetAddress;
  late String aptNumber;
  late String city;
  late String zipCode;

  late String basePrice;
  late String tipAmount;
  late String totalPrice;

  PickupRequest({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.packageDescription1,
    required this.QRcode1,
    required this.packageDescription2,
    required this.QRcode2,
    required this.packageDescription3,
    required this.QRcode3,
    required this.packageDescription4,
    required this.QRcode4,
    required this.dayOfPickup,
    required this.timeFrameOfPickup,
    required this.streetAddress,
    required this.aptNumber,
    required this.city,
    required this.zipCode,
    required this.basePrice,
    required this.tipAmount,
    required this.totalPrice,
  });

  PickupRequest.blank() {
    firstName = "firstname";
    lastName = "lastName";
    phoneNumber = "555-555-5555";
    packageDescription1 = "Item1";
    QRcode1 = "QRCode1";
    packageDescription2 = "Item2";
    QRcode2 = "QRCode2";
    packageDescription3 = "Item3";
    QRcode3 = "QRCode3";
    packageDescription4 = "Item4";
    QRcode4 = "QRCode4";
    dayOfPickup = "Today";
    timeFrameOfPickup = "timeFrame";
    aptNumber = "123";
    city = "city";
    zipCode = "zipCode";
    basePrice = "3.99";
    tipAmount = "2";
    totalPrice = "5.99";
  }

  Map<String, dynamic> toJson() => _pickupRequestToJson(this);

  factory PickupRequest.fromJson(Map<String, dynamic> json) =>
      _pickupRequestFromJson(json);

  factory PickupRequest.fromSnapshot(DocumentSnapshot snapshot) {
    final newPickupRequest =
        PickupRequest.fromJson(snapshot.data() as Map<String, dynamic>);
    newPickupRequest.pickupRequestID = snapshot.reference.id;
    return newPickupRequest;
  }
}

PickupRequest _pickupRequestFromJson(Map<String, dynamic> json) {
  return PickupRequest(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    phoneNumber: json['phoneNumber'] as String,
    packageDescription1: json['packageDescription1'] as String,
    QRcode1: json['QRCode1'] as String,
    packageDescription2: json['packageDescription2'] as String,
    QRcode2: json['QRCode2'] as String,
    packageDescription3: json['packageDescription3'] as String,
    QRcode3: json['QRCode3'] as String,
    packageDescription4: json['packageDescription4'] as String,
    QRcode4: json['QRCode4'] as String,
    dayOfPickup: json['dayOfPickup'] as String,
    timeFrameOfPickup: json['timeFrameOfPickup'] as String,
    streetAddress: json['streetAddress'] as String,
    aptNumber: json['aptNumber'] as String,
    city: json['city'],
    zipCode: json['zipCode'],
    basePrice: json['basePrice'],
    tipAmount: json['tipAmount'],
    totalPrice: json['totalPrice'],
  );
}

Map<String, dynamic> _pickupRequestToJson(PickupRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'packageDescription1': instance.packageDescription1,
      'QRCode1': instance.QRcode1,
      'packageDescription2': instance.packageDescription2,
      'QRCode2': instance.QRcode2,
      'packageDescription3': instance.packageDescription3,
      'QRCode3': instance.QRcode3,
      'packageDescription4': instance.packageDescription4,
      'QRCode4': instance.QRcode4,
      'dayOfPickup': instance.dayOfPickup,
      'timeFrameOfPickup': instance.timeFrameOfPickup,
      'streetAddress': instance.streetAddress,
      'aptNumber': instance.aptNumber,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'basePrice': instance.basePrice,
      'tipAmount': instance.tipAmount,
      'totalPrice': instance.totalPrice,
    };
