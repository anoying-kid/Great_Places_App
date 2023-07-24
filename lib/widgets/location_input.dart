import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:great_places_app/helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  Future<void> _getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final locData = await Geolocator.getCurrentPosition();
    final staticMapImage = LocationHelper.generatLocationPreviewImage(
        locData.latitude, locData.longitude);
    setState(() {
      _previewImageUrl = staticMapImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            child: _previewImageUrl == null
                ? Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  )
                : Image.network(
                    _previewImageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.location_on),
                onPressed: () async {
                  await _getCurrentLocation();
                },
                label: Text('Current Location'),
                style: TextButton.styleFrom(
                  // backgroundColor: Theme.of(context).primaryColor,
                  iconColor: Theme.of(context).primaryColor,
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.map),
                onPressed: () {},
                label: Text('Select on Map'),
                style: TextButton.styleFrom(
                  // backgroundColor: Theme.of(context).primaryColor,
                  iconColor: Theme.of(context).primaryColor,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
