import 'package:easyreturns/DAOS/pickupRequestDao.dart';
import 'package:easyreturns/models/PickupRequest.dart';
import 'package:easyreturns/widgets/PickupRequestWidgets/PackageItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocode/geocode.dart';

import '../shared/DeliveryInfoParent.dart';
import 'package:intl/intl.dart';

import '../widgets/PickupRequestWidgets/CustomInput.dart';

class NewPickupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewPickupScreen();
  }
}

class _NewPickupScreen extends State<NewPickupScreen> {
  bool isValidForm = false;

  // Holds the info about user and delivery Location
  DeliveryInfoParent deliveryInfoParent = DeliveryInfoParent();

  // Current Max items in one delivery = 4 separate items
  final TextEditingController _mainPackageDescription = TextEditingController();
  List<TextEditingController> currentPackageDescriptionControllers =
      List.empty(growable: true);
  List<TextEditingController> allPackageDescriptionControllers =
      List.empty(growable: true);

  List<PackageItem> additionalPackageItems = List.empty(growable: true);

  removeListItem(PackageItem itemToRemove) {
    setState(() {
      TextEditingController controllerToRemove =
          itemToRemove.descriptionController;
      int indexOfItemToRemove = additionalPackageItems.indexOf(itemToRemove);
      additionalPackageItems.remove(itemToRemove);
      currentPackageDescriptionControllers.remove(controllerToRemove);

      // Updating the submittable value to "" so that only
      // current/correct values are submitted
      if (indexOfItemToRemove != -1) {
        allPackageDescriptionControllers[indexOfItemToRemove].text = "";
      }
    });
  }

  addListItem() {
    setState(() {
      int currIndex = additionalPackageItems.length;

      TextEditingController currController = TextEditingController();
      allPackageDescriptionControllers[currIndex] = currController;
      additionalPackageItems.add(
        PackageItem(
          indexInList: currIndex,
          elevatedButtonStyle: elevatedButtonStyle,
          descriptionController: currController,
          removeThisItemCallback: removeListItem,
        ),
      );
      currentPackageDescriptionControllers.add(currController);
    });
  }

  double currentPriceOfOurService = 3.99;

  DateTime? currentDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime todaysDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  showFlutterDatePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: todaysDate,
      firstDate: todaysDate,
      lastDate: DateTime(DateTime.now().year + 1),
    );
    setState(() {
      currentDate = newDate;
      currentDate ??= todaysDate;
    });
  }

  @override
  void initState() {
    super.initState();
    currentTimeFrameChosen = earlyTimeFrame;

    const int numAdditionalPackagesAllowed = 3;
    for (int i = 0; i < numAdditionalPackagesAllowed; i++) {
      allPackageDescriptionControllers.add(TextEditingController());
    }
  }

  int currentStep = 0;
  final String earlyTimeFrame = "9 am - 12 noon";
  final String afternoonTimeFrame = "12 noon - 3 pm";
  final String earlyEveningTimeFrame = "3 pm - 6 pm";
  final String lateEveningTimeFrame = "6 pm - 9 pm";
  String? currentTimeFrameChosen;

  int currentTipAmount = 0;
  List<bool> tipsActivation = [false, false, false, false];
  setValueOfTips(int index, int amountToSet) {
    setState(() {
      if (tipsActivation[index]) {
        currentTipAmount = 0;
        tipsActivation[index] = false;
        return;
      }

      tipsActivation = [false, false, false, false];
      tipsActivation[index] = true;
      currentTipAmount = amountToSet;
    });
  }

  var elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blueGrey,
    foregroundColor: Colors.white,
  );
  var elevatedButtonSelectedStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.deepOrange[300] as Color,
    foregroundColor: Colors.white,
  );
  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text("Account Info"),
        content: Column(
          children: [
            CustomInput(
              hint: "First Name",
              inputBorder: const OutlineInputBorder(),
              controller: deliveryInfoParent.firstNameController,
            ),
            CustomInput(
              hint: "Last Name",
              inputBorder: const OutlineInputBorder(),
              controller: deliveryInfoParent.lastNameController,
            ),
            CustomInput(
              hint: "Phone Number",
              inputBorder: const OutlineInputBorder(),
              controller: deliveryInfoParent.phoneNumberController,
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Package Info"),
        content: Column(
          children: [
            PackageItem(
              indexInList: -1,
              elevatedButtonStyle: elevatedButtonStyle,
              descriptionController: _mainPackageDescription,
              removeThisItemCallback: removeListItem,
              isFirst: true,
            ),
            ...additionalPackageItems,
            Padding(
              padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width * 0.125)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: (additionalPackageItems.length < 3)
                      ? () => {
                            addListItem(),
                          }
                      : null,
                  style: elevatedButtonStyle,
                  child: const Text('Add another package?'),
                ),
              ),
            )
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Pickup Date"),
        content: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () => {
                      showFlutterDatePicker(),
                    },
                    style: elevatedButtonStyle,
                    child: const Text(
                      'Select Day for Pickup',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(DateFormat.yMMMEd().format(currentDate!),
                      style: const TextStyle(fontStyle: FontStyle.italic)),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                "What time frame would you like this be picked up?",
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownButton(
                items: [
                  DropdownMenuItem(
                    value: earlyTimeFrame,
                    child: Text(earlyTimeFrame),
                  ),
                  DropdownMenuItem(
                    value: afternoonTimeFrame,
                    child: Text(afternoonTimeFrame),
                  ),
                  DropdownMenuItem(
                    value: earlyEveningTimeFrame,
                    child: Text(earlyEveningTimeFrame),
                  ),
                  DropdownMenuItem(
                    value: lateEveningTimeFrame,
                    child: Text(lateEveningTimeFrame),
                  ),
                ],
                value: currentTimeFrameChosen,
                onChanged: (value) {
                  setState(() {
                    currentTimeFrameChosen = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Pickup Location"),
        content: Column(
          children: [
            CustomInput(
              hint: "Street Address",
              inputBorder: const OutlineInputBorder(),
              controller: deliveryInfoParent.streetAddressController,
            ),
            CustomInput(
              hint: "Apt/Building Number",
              inputBorder: const OutlineInputBorder(),
              controller: deliveryInfoParent.aptBuildingNumController,
            ),
            CustomInput(
              hint: "City",
              inputBorder: const OutlineInputBorder(),
              controller: deliveryInfoParent.cityController,
            ),
            CustomInput(
              hint: "Zip Code",
              inputBorder: const OutlineInputBorder(),
              controller: deliveryInfoParent.zipCodeController,
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        title: const Text("Payment"),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  const Text(
                    "Current Price:   ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "\$$currentPriceOfOurService",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Tips:',
                    style: TextStyle(
                      fontSize: 18,
                    )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => {setValueOfTips(0, 2)},
                  style: (tipsActivation[0])
                      ? elevatedButtonSelectedStyle
                      : elevatedButtonStyle,
                  child: const Text("\$2"),
                ),
                ElevatedButton(
                  onPressed: () => {setValueOfTips(1, 3)},
                  style: (tipsActivation[1])
                      ? elevatedButtonSelectedStyle
                      : elevatedButtonStyle,
                  child: const Text("\$3"),
                ),
                ElevatedButton(
                  onPressed: () => {setValueOfTips(2, 4)},
                  style: (tipsActivation[2])
                      ? elevatedButtonSelectedStyle
                      : elevatedButtonStyle,
                  child: const Text("\$4"),
                ),
                ElevatedButton(
                  onPressed: () => {setValueOfTips(3, 8)},
                  style: (tipsActivation[3])
                      ? elevatedButtonSelectedStyle
                      : elevatedButtonStyle,
                  child: const Text("\$8"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  const Text(
                    "Total Price:     ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "\$${currentPriceOfOurService + currentTipAmount}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  String gatherFullAddress(String streetAddress, String city, String zipCode) {
    return "$streetAddress, $city, ${(zipCode.isNotEmpty) ? zipCode : ''}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Pickup Request'),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Stepper(
            type: StepperType.vertical,
            currentStep: currentStep,
            onStepCancel: () => currentStep == 0
                ? null
                : setState(() {
                    currentStep -= 1;
                  }),
            onStepContinue: () async {
              bool isLastStep = (currentStep == getSteps().length - 1);
              if (isLastStep) {
                // In the future validate instead of saying "blank"
                temporaryValidateControllers();

                String fullAddress = gatherFullAddress(
                    deliveryInfoParent.streetAddressController.text,
                    deliveryInfoParent.cityController.text,
                    deliveryInfoParent.zipCodeController.text);

                GeoCode geoCode = GeoCode();

                double pickupLatitude = 40.25;
                double pickupLongitude = -111.6562;

                try {
                  Coordinates coordinates =
                      await geoCode.forwardGeocoding(address: fullAddress);

                  if (coordinates.latitude != null &&
                      coordinates.longitude != null) {
                    pickupLatitude = coordinates.latitude as double;
                    pickupLongitude = coordinates.longitude as double;
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }

                PickupRequest request = PickupRequest(
                  firstName: deliveryInfoParent.firstNameController.text,
                  lastName: deliveryInfoParent.lastNameController.text,
                  phoneNumber: deliveryInfoParent.phoneNumberController.text,
                  packageDescription1: _mainPackageDescription.text,
                  QRcode1: "Nothing1",
                  packageDescription2: allPackageDescriptionControllers[0].text,
                  QRcode2: "Nothing2",
                  packageDescription3: allPackageDescriptionControllers[1].text,
                  QRcode3: "Nothing3",
                  packageDescription4: allPackageDescriptionControllers[2].text,
                  QRcode4: "Nothing4",
                  dayOfPickup: DateFormat.yMMMEd().format(currentDate!),
                  timeFrameOfPickup: currentTimeFrameChosen as String,
                  streetAddress:
                      deliveryInfoParent.streetAddressController.text,
                  aptNumber: deliveryInfoParent.aptBuildingNumController.text,
                  city: deliveryInfoParent.cityController.text,
                  zipCode: deliveryInfoParent.zipCodeController.text,
                  basePrice: "$currentPriceOfOurService",
                  tipAmount: "$currentTipAmount",
                  totalPrice: "${currentPriceOfOurService + currentTipAmount}",
                  latitude: pickupLatitude.toString(),
                  longitude: pickupLongitude.toString(),
                );

                PickupRequestDao pickupRequestDao = PickupRequestDao();
                pickupRequestDao.addPickupRequest(request);

                // Just in case the context gets corrupted
                if (!mounted) return;
                Navigator.pushNamed(context, '/home');
              } else {
                setState(() {
                  currentStep += 1;
                });
              }
            },
            onStepTapped: (step) => setState(() {
              currentStep = step;
            }),
            steps: getSteps(),
          )),
    );
  }

  void temporaryValidateControllers() {
    if (deliveryInfoParent.firstNameController.text.isEmpty) {
      deliveryInfoParent.firstNameController.text = "blank";
    }
    if (deliveryInfoParent.lastNameController.text.isEmpty) {
      deliveryInfoParent.lastNameController.text = "blank";
    }
    if (deliveryInfoParent.phoneNumberController.text.isEmpty) {
      deliveryInfoParent.phoneNumberController.text = "blank";
    }
    if (_mainPackageDescription.text.isEmpty) {
      _mainPackageDescription.text = "blank";
    }
    for (int i = 0; i < allPackageDescriptionControllers.length; i++) {
      if (allPackageDescriptionControllers[i].text.isEmpty) {
        allPackageDescriptionControllers[i].text = "blank";
      }
    }
    if (deliveryInfoParent.streetAddressController.text.isEmpty) {
      deliveryInfoParent.streetAddressController.text = "blank";
    }
    if (deliveryInfoParent.aptBuildingNumController.text.isEmpty) {
      deliveryInfoParent.aptBuildingNumController.text = "blank";
    }
    if (deliveryInfoParent.cityController.text.isEmpty) {
      deliveryInfoParent.cityController.text = "blank";
    }
    if (deliveryInfoParent.zipCodeController.text.isEmpty) {
      deliveryInfoParent.zipCodeController.text = "blank";
    }
  }
}
