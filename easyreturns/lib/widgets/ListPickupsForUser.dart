import 'package:easyreturns/models/PickupRequest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPickupsForUser extends StatelessWidget {
  const ListPickupsForUser({super.key});

  List<Padding> buildPickupRequestCards(List<PickupRequest> requests) {
    List<Padding> currList = List.empty(growable: true);
    for (var request in requests) {
      List<String> packageDescriptions = List.empty(growable: true);
      packageDescriptions.add(request.packageDescription1);
      if (request.packageDescription2 != "blank") {
        packageDescriptions.add(request.packageDescription2);
      }
      if (request.packageDescription3 != "blank") {
        packageDescriptions.add(request.packageDescription3);
      }
      if (request.packageDescription4 != "blank") {
        packageDescriptions.add(request.packageDescription4);
      }

      String packageDescriptionString = "";
      for (String description in packageDescriptions) {
        packageDescriptionString += "$description\n";
      }
      currList.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
                leading: const Icon(Icons.schedule_send_outlined),
                title: Text(
                    "Pickup Day:       ${request.dayOfPickup.substring(0, request.dayOfPickup.length - 6)}\nScheduled At:   ${request.timeFrameOfPickup}"),
                subtitle: Text(packageDescriptionString)),
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
