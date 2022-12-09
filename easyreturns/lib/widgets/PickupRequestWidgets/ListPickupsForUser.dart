import 'package:easyreturns/models/PickupRequest.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ListPickupsForUser extends StatelessWidget {
  const ListPickupsForUser({super.key});

  List<Padding> buildPickupRequestCards(List<PickupRequest> requests) {
    List<Padding> currList = List.empty(growable: true);
    for (var request in requests) {
      List<String> additionalPackageDescriptions = List.empty(growable: true);
      if (request.packageDescription2 != "blank") {
        additionalPackageDescriptions.add(request.packageDescription2);
      }
      if (request.packageDescription3 != "blank") {
        additionalPackageDescriptions.add(request.packageDescription3);
      }
      if (request.packageDescription4 != "blank") {
        additionalPackageDescriptions.add(request.packageDescription4);
      }

      DateTime dayOfPickup = DateFormat.yMMMEd().parse(request.dayOfPickup);
      String dayOfMonth = request.dayOfPickup.substring(5, 11);
      debugPrint(request.dayOfPickup);
      String relativeDay = Jiffy(dayOfPickup).fromNow();
      if (dayOfPickup.day == DateTime.now().day) {
        relativeDay = "Today";
      } else if (dayOfPickup.day == (DateTime.now().day + 1)) {
        relativeDay = "Tomorrow";
      } else if (dayOfPickup.day == (DateTime.now().day - 1)) {
        relativeDay = "Yesterday";
      } // else if (dayOfPickup.isBefore(DateTime.now())) {
      //   relativeDay = "Overdue";
      // }

      String packageDescriptionString = request.packageDescription1;
      for (String description in additionalPackageDescriptions) {
        packageDescriptionString += "\n$description";
      }
      currList.add(
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 8.0,
            bottom: 0.0,
            right: 8.0,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                bottom: 12.0,
              ),
              child: ListTile(
                  minLeadingWidth: 0.0,
                  leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.schedule_send_outlined),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text(
                          //   "Pickup of:",
                          //   style: TextStyle(
                          //     fontSize: 22,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          Text(packageDescriptionString),
                        ]),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Pickup is $relativeDay ($dayOfMonth)\nbetween ${request.timeFrameOfPickup}"),
                    ],
                  )),
            ),
          ),
        ),
      );
    }
    if (currList.isEmpty) {
      currList.add(
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Text(
                  // ignore: prefer_adjacent_string_concatenation
                  "Currently no outgoing requests.\n" +
                      "Press the button below to add a new request",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return currList;
  }

  @override
  Widget build(BuildContext context) {
    var requests = Provider.of<List<PickupRequest>>(context);

    return ListView(
      shrinkWrap: true,
      children: [...buildPickupRequestCards(requests)],
    );
  }
}
