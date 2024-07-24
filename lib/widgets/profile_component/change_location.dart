import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:order_up/models/profile_data.dart';

class ChangeLocation extends StatefulWidget {
  final ProfileLocation? selectedLocationMap;
  final void Function(double, double) setLocation;

  const ChangeLocation({
    super.key,
    required this.selectedLocationMap,
    required this.setLocation,
  });

  @override
  State<ChangeLocation> createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  ProfileLocation? _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.selectedLocationMap;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                onTap: _pickLocation,
                decoration: InputDecoration(
                  hintText: _currentLocation?.toString() ?? 'Location',
                ),
              ),
            ),
            IconButton(
              onPressed: _pickLocation,
              icon: const Icon(Icons.location_on),
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  void _pickLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled.');
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = ProfileLocation(
          latitude: position.latitude, longitude: position.longitude);
    });

    // Here you can save the location to Firebase Realtime Database
    widget.setLocation(position.latitude, position.longitude);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // void setLocation(double latitude, double longitude) {
  //   log("Latitude: $latitude");
  //   log("Longitude: $longitude");

  //   // Implement the logic to save the location to Firebase Realtime Database
  //   // Use the latitude and longitude values to save the location
  //   // Example: databaseRef.child('users').child(userId).update({'location': 'latitude, longitude'});
  // }
}
