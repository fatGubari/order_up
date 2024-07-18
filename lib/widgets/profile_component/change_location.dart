import 'package:flutter/material.dart';

class ChangeLocation extends StatefulWidget {
  final String selectedLocationMap;
  const ChangeLocation({super.key, required this.selectedLocationMap,});

  @override
  State<ChangeLocation> createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
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
                  hintText: 'Location',
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

    void _pickLocation(BuildContext context) {
    // Implement location selection logic using Google Maps
    // You can use the google_maps_flutter plugin to display a map and get the selected location
    // For example:
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()));
    // In the MapScreen, you can use GoogleMap widget to display the map and allow the user to select a location
    // After the user selects a location, you can set the selectedLocation and selectedLocationLatLng variables
  }

}