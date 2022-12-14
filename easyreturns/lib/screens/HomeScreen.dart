import 'package:easyreturns/ChangeNotifiers/requestMapDetailsNotifier.dart';
import 'package:easyreturns/models/PickupRequest.dart';
import 'package:easyreturns/widgets/MapWidgets/MapWidget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../ChangeNotifiers/IsMapReadyNotifier.dart';
import '../widgets/MapWidgets/MapTab.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => IsMapReadyNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => RequestMapDetailsNotifier(),
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
            const MapTab(),
          ],
        ),
      ),
    );
  }
}
