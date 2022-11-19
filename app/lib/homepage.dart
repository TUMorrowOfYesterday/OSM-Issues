import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:tuple/tuple.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Position? userPosition;

  // automatic location updates
  StreamSubscription<Position>? positionStream;
  late Timer timer;

  static Map<int, Tuple2<double, double>> mockIssues = {
    0: Tuple2(13.0, 14.2),
    1: Tuple2(48.0, 11.2),
    2: Tuple2(20.0, -9.2),
    3: Tuple2(64.0, -45.2)
  };

  List<Marker> mapToMarker() {
    List<Marker> markers = [];
    mockIssues.forEach((key, value) {
      markers.add(Marker(
          point: LatLng(value.item1, value.item2),
          width: 80,
          height: 80,
          builder: (context) => Icon(Icons.location_on)));
    });

    return markers;
  }

  ensureLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return true;
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    ensureLocationPermission();

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  //Fetch issue
  //update avatar
  //fetch others position
  void updateServer() {
    // String serverUrl;
    // http.get(Uri.parse("http://"+serverUrl+"/"))
  }

  @override
  void initState() {
    super.initState();
    ensureLocationPermission().then((value) {
      //TODO: check value for whether it was successful or not
      positionStream = Geolocator.getPositionStream(
          locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      )).listen((Position? position) {
        if (position != null) {
          setState(() {
            userPosition = position;
          });
        }
      });
    });

    // periodic updater
    timer = Timer.periodic(Duration(seconds: 1), ((timer) => updateServer()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(51.509364, -0.128928),
            zoom: 9.2,
          ),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap',
              onSourceTapped: () {},
            ),
            // UI OVERLAY BUTTONS ETC HERE
            // Expanded(
            //   child: Center(
            //     child: Text("HELLO WORLDl\nasdjfladsjflksafjalks"),
            //   ),
            // )
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            // Layer where we can put our custom markers (see https://docs.fleaflet.dev/usage/layers/marker-layer)
            MarkerLayer(
              markers: [
                    Marker(
                      //current position
                      point: userPosition == null
                          ? LatLng(30, 40)
                          : LatLng(
                              userPosition!.latitude, userPosition!.longitude),
                      width: 80,
                      height: 80,
                      builder: (context) => Icon(Icons.navigation),
                    ),
                  ] +
                  mapToMarker(),
              rotate: true, //counter rotate to keep marker upright
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
