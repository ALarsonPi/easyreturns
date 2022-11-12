import 'package:flutter/material.dart';

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
    return DefaultTabController(
      length: _numTabs,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FloatingActionButton.extended(
            onPressed: () => {},
            icon: const Icon(Icons.add),
            label: const Text('Request new Pickup'),
          ),
        ),
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
            Column(
              children: const [
                Icon(Icons.flight, size: 350),
              ],
            ),
            Column(
              children: const [
                Icon(Icons.directions_transit, size: 350),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
