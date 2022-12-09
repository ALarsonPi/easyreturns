import 'package:easyreturns/models/PickupRequest.dart';
import 'package:easyreturns/widgets/MapWidgets/MapWidget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../ChangeNotifiers/IsMapReadyNotifier.dart';
import '../widgets/PickupRequestWidgets/ListPickupsForUser.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  final int _numTabs = 2;
  bool isRequestTab = true;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _numTabs, vsync: this);

    _controller.addListener(() {
      setState(() {
        isRequestTab = (_controller.index == 0);
      });
    });
  }

  PermissionStatus _permissionStatus = PermissionStatus.denied;
  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() {
      _permissionStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => IsMapReadyNotifier(),
        ),
      ],
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (isRequestTab)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: FloatingActionButton.extended(
                  onPressed: () => {
                    Navigator.pushNamed(context, '/new-pickup'),
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Request new Pickup'),
                ),
              )
            : null,
        appBar: AppBar(
          centerTitle: true,
          bottom: TabBar(
            controller: _controller,
            tabs: const [
              Tab(icon: Icon(Icons.send)),
              Tab(icon: Icon(Icons.drive_eta_sharp)),
            ],
          ),
          title: Text(
            (isRequestTab) ? 'Your Return Requests' : 'Available Pickups',
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            ListView(
              shrinkWrap: true,
              children: const [
                ListPickupsForUser(),
              ],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Provider.of<IsMapReadyNotifier>(context, listen: true)
                        .hasLocationPermission
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        child: const MapWidget(),
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
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.lightBlue),
                              ),
                            )),
                            onPressed: () async => {
                              if (!isRequestTab && !_permissionStatus.isGranted)
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
            ),
          ],
        ),
      ),
    );
  }
}
