import 'package:easyreturns/shared/DeliveryInfoParent.dart';
import 'package:easyreturns/shared/LoginInfoParent.dart';
import 'package:flutter/material.dart';

import '../widgets/PickupRequestWidgets/CustomInput.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreen();
  }
}

class _RegisterScreen extends State<RegisterScreen> {
  int currentStep = 0;
  bool isOnLastStep = false;
  DeliveryInfoParent deliveryInfoParent = DeliveryInfoParent();
  LoginInfoParent loginInfoParent = LoginInfoParent();
  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text("Account"),
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
        title: const Text("Delivery"),
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
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Login"),
        content: Column(
          children: [
            CustomInput(
              hint: "Username",
              inputBorder: const OutlineInputBorder(),
              controller: loginInfoParent.usernameController,
            ),
            CustomInput(
              hint: "Password",
              inputBorder: const OutlineInputBorder(),
              controller: loginInfoParent.passwordController,
            ),
          ],
        ),
      ),
    ];
  }

  checkAndSetLastStep() {
    setState(() {
      isOnLastStep = (currentStep == getSteps().length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height,
              child: Stepper(
                type: StepperType.horizontal,
                controlsBuilder: (BuildContext ctx, ControlsDetails dtl) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: ElevatedButton(
                          onPressed: dtl.onStepContinue,
                          child: Text(isOnLastStep == true ? 'SUBMIT' : 'NEXT'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: TextButton(
                            onPressed: dtl.onStepCancel,
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  return Colors.transparent;
                                },
                              ),
                            ),
                            child: const Text('BACK',
                                style: TextStyle(
                                    backgroundColor: Colors.transparent)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                currentStep: currentStep,
                onStepCancel: () => currentStep == 0
                    ? null
                    : setState(() {
                        currentStep -= 1;
                        checkAndSetLastStep();
                      }),
                onStepContinue: () {
                  bool isLastStep = (currentStep == getSteps().length - 1);
                  if (isLastStep) {
                    // In the future validate instead of saying "blank"

                  } else {
                    setState(() {
                      currentStep += 1;
                      checkAndSetLastStep();
                    });
                  }
                },
                onStepTapped: (step) => setState(() {
                  currentStep = step;
                  checkAndSetLastStep();
                }),
                steps: getSteps(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
