import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  Future getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("Service Disabled");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  openGoogleMap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text("get location"),
              onPressed: () async {
                _currentLocation = await getCurrentLocation();
                print(_currentLocation!.latitude);
                print(_currentLocation!.longitude);
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  String url =
                      "https://maps.google.com/?q=${_currentLocation!.latitude},${_currentLocation!.longitude}";
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text("open map"))
          ],
        ),
      ),
    );
  }
}
