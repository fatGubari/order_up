import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ChangeLocation extends StatefulWidget {
  final String selectedLocationMap;
  const ChangeLocation({
    super.key,
    required this.selectedLocationMap,
  });

  @override
  State<ChangeLocation> createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  String? _currentLocation;

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
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                onTap: () {
                  _pickLocation(context);
                },
                decoration: InputDecoration(
                  hintText: _currentLocation ?? 'Location',
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _pickLocation(context);
              },
              icon: Icon(Icons.location_on),
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location services are disabled.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permissions are denied'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = '${position.latitude}, ${position.longitude}';
    });

    // Here you can save the location to Firebase Realtime Database
    _saveLocationToFirebase(position.latitude, position.longitude);
  }

  void _saveLocationToFirebase(double latitude, double longitude) {
    // Implement the logic to save the location to Firebase Realtime Database
    // Use the latitude and longitude values to save the location
    // Example: databaseRef.child('users').child(userId).update({'location': 'latitude, longitude'});
  }
}
