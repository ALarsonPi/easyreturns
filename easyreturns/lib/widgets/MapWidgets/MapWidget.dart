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

  static const CameraPosition _utahProvo = CameraPosition(
    target: LatLng(40.233845, -111.658531),
    zoom: 14.4746,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _addMarker(String id, double? latitude, double? longitude) {
    var markerIdVal = id;
    final MarkerId markerId = MarkerId(markerIdVal);

    double latitudePosition = latitude ?? _utahProvo.target.latitude + 0.01;
    double longitudePosition = longitude ?? _utahProvo.target.longitude + 0.01;

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
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  _setMarkers(BuildContext context) async {
    var streamedRequests = Provider.of<List<PickupRequest>>(context);

    for (PickupRequest request in streamedRequests) {
      final fullAddress =
          "${request.streetAddress},${request.city},${request.zipCode}";

      GeoCode geoCode = GeoCode();

      try {
        Coordinates coordinates =
            await geoCode.forwardGeocoding(address: fullAddress);

        debugPrint("Latitude: ${coordinates.latitude}");
        debugPrint("Longitude: ${coordinates.longitude}");
        _addMarker(request.pickupRequestID.toString(), coordinates.latitude,
            coordinates.longitude);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  _onMarkerTapped(MarkerId markerId) {}

  @override
  Widget build(BuildContext context) {
    //_setMarkers(context);

    _addMarker("first", 40.25063, -111.65615);
    _addMarker("second", 40.26303, -111.66988);

    Widget theMap = GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: _utahProvo,
      onMapCreated: (GoogleMapController controller) {
        // _controller = controller;
        _controller.complete(controller);

        Provider.of<IsMapReadyNotifier>(context, listen: false)
            .setIsMapReady(true);
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
