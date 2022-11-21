import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:app/Challenge/newchallenge.dart';
import 'package:app/camera.dart';
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
import '../globals.dart' as globals;

import '../Challenge/currentchallenge.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> avatarList = [
    "assets/avatar/cat.png",
    "assets/avatar/panda.png",
    "assets/avatar/pinguin.png"
  ];

  Position? userPosition;

  // automatic location updates
  StreamSubscription<Position>? positionStream;
  late Timer timer;

  List? openIssues;

  List? publicPeople;

  List<Marker> mapToMarker() {
    List<Marker> markers = [];
    if (openIssues == null) return markers;

    for (var issue in openIssues!) {
      if (issue[3] != 0.0) {
        continue;
      }
      markers.add(Marker(
        point: LatLng(issue[2], issue[1]),
        width: 80,
        height: 80,
        builder: (context) => GestureDetector(
          onTap: () => Navigator.push(
              context,
              CustomRoute(
                destination: NewChallenge(issueId: issue[0]),
                darken: true,
              )),
          child: const Icon(
            Icons.location_on,
            size: 50,
          ),
        ),
      ));
    }

    return markers;
  }

  List<CircleMarker> mapToCircleMarker() {
    List<CircleMarker> markers = [];
    if (openIssues == null) return markers;

    for (var issue in openIssues!) {
      if (issue[3] == 0.0) {
        continue;
      }
      markers.add(CircleMarker(
          point: LatLng(issue[5], issue[4]),
          color: Colors.blue.withOpacity(0.3),
          borderStrokeWidth: 3.0,
          borderColor: Colors.blue,
          useRadiusInMeter: true,
          radius: 1000));
    }

    return markers;
  }

  List<Marker> maptoAvatar() {
    List<Marker> markers = [];
    if (publicPeople == null) return markers;

    for (var user in publicPeople!) {
      markers.add(
        Marker(
          //current position
          point: LatLng(user[3], user[2]),
          width: 80,
          height: 80,
          builder: (context) => IconButton(
            icon: Image.asset(avatarList[user[4]]),
            iconSize: 10,
            onPressed: () {},
          ),
          //const Icon(Icons.navigation),
        ),
      );
    }

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
  void updateServer() async {
    try {
      var response =
          await http.get(Uri.parse(globals.serverUrl + "get_openIssues"));
      if (response.statusCode == 200)
        setState(() {
          openIssues = jsonDecode(response.body);
        });

      response =
          await http.get(Uri.parse(globals.serverUrl + "get_OthersPosition"));
      if (response.statusCode == 200)
        setState(() {
          publicPeople = jsonDecode(response.body);
        });

      if (userPosition != null) {
        response = await http.post(Uri.parse(globals.serverUrl +
            "update_Position?user=${globals.userId}&longitude=${userPosition!.longitude}&latitude=${userPosition!.latitude}"));
      }
    } catch (e) {
      print(e);
    }
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
            // userPosition = position;
            userPosition = Position(
              latitude: position.latitude,
              longitude: position.longitude + Random().nextDouble() / 100,
              timestamp: position.timestamp,
              accuracy: position.accuracy,
              altitude: position.altitude,
              heading: position.heading,
              speed: position.speed,
              speedAccuracy: position.speedAccuracy,
            );
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
            center: LatLng(48.149145, 11.567577),
            zoom: 9.2,
          ),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap',
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
            CircleLayer(
              circles: [
                    CircleMarker(
                        point: LatLng(51.509364, -0.128928),
                        color: Colors.blue.withOpacity(0.3),
                        borderStrokeWidth: 3.0,
                        borderColor: Colors.blue,
                        useRadiusInMeter: true,
                        radius: 100)
                  ] +
                  mapToCircleMarker(),
            ),
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
                      builder: (context) => IconButton(
                        icon: Image.asset(avatarList[globals.avatarId]),
                        iconSize: 10,
                        onPressed: () {},
                      ),
                      //const Icon(Icons.navigation),
                    ),
                  ] +
                  mapToMarker() +
                  maptoAvatar(),
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

class CustomRoute extends PageRouteBuilder {
  final Widget destination;
  final bool darken;

  CustomRoute({required this.destination, this.darken = false})
      : super(
            opaque: false,
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
              Widget child,
            ) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return Stack(
                children: <Widget>[
                  FrostTransition(
                    animation: new Tween<double>(
                      begin: 0.0,
                      end: 5.0,
                    ).animate(animation),
                    darken: darken,
                  ),
                  /*FadeTransition(
                opacity: animation,
                child: child,
              ),*/
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: const Offset(0, 0),
                    ).animate(animation),
                    child: child,
                  )
                ],
              );
            },
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
            ) {
              return destination;
            });
}

class FrostTransition extends AnimatedWidget {
  final Animation<double> animation;
  final bool darken;

  FrostTransition({required this.animation, required this.darken})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) => new BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: animation.value, sigmaY: animation.value),
        child: Container(
          color: darken
              ? Colors.black.withOpacity(animation.value * 0.1)
              : Colors.white.withOpacity(0.0),
        ),
      );
}
