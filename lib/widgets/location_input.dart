import 'package:flutter/material.dart';

import '../screens/map_screen.dart';
import 'package:location/location.dart';
import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  // bool? _serviceEnabled;
  // PermissionStatus? _permissionGranted;

  Future<void> _getCurrentUserLocation() async {
    // _serviceEnabled = await Location().serviceEnabled();
    // if (!_serviceEnabled) _serviceEnabled = await Location().requestService();

    // _permissionGranted = await Location().hasPermission();
    // if (_permissionGranted == PermissionStatus.denied)
    //   _permissionGranted = await Location().requestPermission();

    final locationData = await Location().getLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: locationData.latitude, longitude: locationData.longitude);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MapScreen(
              isSelecting: true,
            )));
    if (selectedLocation == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl as String,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.location_on,
              ),
              label: Text('Current Location'),
              // textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: Icon(
                Icons.map,
              ),
              label: Text('Select on Map'),
              // textColor: Theme.of(context).primaryColor,
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
