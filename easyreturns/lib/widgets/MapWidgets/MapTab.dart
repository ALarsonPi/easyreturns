import 'package:easyreturns/widgets/MapWidgets/MapTextDisplay.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../ChangeNotifiers/IsMapReadyNotifier.dart';
import 'MapWidget.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MapTab();
  }
}

class _MapTab extends State<MapTab> {
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() {
      _permissionStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Provider.of<IsMapReadyNotifier>(context, listen: true)
                .hasLocationPermission
            ? Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: const MapWidget(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width,
                    child: const MapTextDisplay(),
                  )
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2,
                    right: MediaQuery.of(context).size.width * 0.2,
                    top: MediaQuery.of(context).size.width * 0.3,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.lightBlue),
                      ),
                    )),
                    onPressed: () async => {
                      if (!_permissionStatus.isGranted)
                        {
                          await requestPermission(Permission.location),
                          if (_permissionStatus.isGranted)
                            {
                              Provider.of<IsMapReadyNotifier>(context,
                                      listen: false)
                                  .setHasLocationPermission(true),
                            },
                        },
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Allow Location Permission to see your Pickups",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
