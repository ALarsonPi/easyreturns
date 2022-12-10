import 'dart:async';
import 'dart:math';
import 'package:easyreturns/ChangeNotifiers/IsMapReadyNotifier.dart';
import 'package:easyreturns/models/PickupRequest.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  // late GoogleMapController _controller;
  final Completer<GoogleMapController> _controller = Completer();

  final double currZoom = 14.0;
  static late CameraPosition _initialPosition;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _addMarker(String id, double? latitude, double? longitude) {
    var markerIdVal = id;
    final MarkerId markerId = MarkerId(markerIdVal);

    double latitudePosition =
        latitude ?? _initialPosition.target.latitude + 0.01;
    double longitudePosition =
        longitude ?? _initialPosition.target.longitude + 0.01;

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        latitudePosition,
        longitudePosition,
      ),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  _setMarkers(BuildContext context) {
    var streamedRequests = Provider.of<List<PickupRequest>>(context);

    for (PickupRequest request in streamedRequests) {
      _addMarker(
        request.pickupRequestID.toString(),
        double.tryParse(request.latitude),
        double.tryParse(request.longitude),
      );
    }

    if (markers.values.isNotEmpty) {
      _initialPosition = CameraPosition(
        target: LatLng(
          markers.values.first.position.latitude,
          markers.values.first.position.longitude,
        ),
        zoom: currZoom,
      );
    }
  }

  _onMarkerTapped(MarkerId markerId) {}

  @override
  Widget build(BuildContext context) {
    // Initial default - middle of PROVO
    _initialPosition = CameraPosition(
      target: LatLng(40.233845, -111.658531),
      zoom: currZoom,
    );
    _setMarkers(context);

    Widget theMap = GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: _initialPosition,
      onMapCreated: (GoogleMapController controller) async {
        _controller.complete(controller);
      },
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
      markers: Set<Marker>.of(markers.values),
    );
    return theMap;

    // This was going to show a progress indicator, but I guess the map itself
    // has to be mounted to actually load as it should
    // return Provider.of<IsMapReadyNotifier>(context, listen: true).isMapReady
    //     ? theMap
    //     : Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: const [
    //           SizedBox(
    //             height: 40,
    //             width: 40,
    //             child: CircularProgressIndicator(),
    //           ),
    //           Padding(
    //             padding: EdgeInsets.only(top: 16.0),
    //             child: Text("Preparing Map"),
    //           ),
    //         ],
    //       );
  }
}
