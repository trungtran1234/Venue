import 'dart:convert';
import 'package:app/functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final int _selectedIndex = 1;
  GoogleMapController? _controller;
  final Location _location = Location();
  final Set<Marker> _markers = {};

  late ConnectivityChecker connectivityChecker;
  late PopupManager popupManager;

  @override
  void initState() {
    super.initState();
    popupManager = PopupManager();
    connectivityChecker = ConnectivityChecker(
      onStatusChanged: onConnectivityChanged,
    );
    _location.onLocationChanged.listen((LocationData currentLocation) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 12.0,
          ),
        ),
      );
    });
  }

  void onConnectivityChanged(bool isConnected) {
    if (isConnected) {
      popupManager.dismissConnectivityPopup();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        popupManager.showConnectivityPopup(context);
      });
    }
  }

  @override
  void dispose() {
    connectivityChecker.dispose();
    super.dispose();
  }

  Future<String> getPlaceAddress(double latitude, double longitude) async {
    const apiKey = '<key>';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].length > 0) {
        return data['results'][0]['formatted_address'];
      }
    }
    return 'Unknown location';
  }

  void _onMapLongPress(LatLng position) async {
    String eventName = '';
    String eventLocation =
        await getPlaceAddress(position.latitude, position.longitude);
    DateTime? startDateTime;
    DateTime? endDateTime;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Event'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Event Name'),
                      onChanged: (value) => eventName = value,
                    ),
                    TextFormField(
                      initialValue: eventLocation,
                      decoration: const InputDecoration(labelText: 'Location'),
                      onChanged: (value) => eventLocation = value,
                    ),
                    ElevatedButton(
                      child: const Text('Select Start Date & Time'),
                      onPressed: () async {
                        final picked = await pickDateTime(startDateTime);
                        if (picked != null) {
                          setState(() => startDateTime = picked);
                        }
                      },
                    ),
                    if (startDateTime != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Start: ${startDateTime.toString()}'),
                      ),
                    ElevatedButton(
                      child: const Text('Select End Date & Time'),
                      onPressed: () async {
                        final picked = await pickDateTime(endDateTime);
                        if (picked != null) {
                          setState(() => endDateTime = picked);
                        }
                      },
                    ),
                    if (endDateTime != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('End: ${endDateTime.toString()}'),
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    if (eventName.isNotEmpty &&
                        startDateTime != null &&
                        endDateTime != null) {
                      setState(() {
                        final markerId =
                            MarkerId(DateTime.now().toIso8601String());
                        _markers.add(
                          Marker(
                            markerId: markerId,
                            position: position,
                            infoWindow: InfoWindow(
                              title: eventName,
                              snippet:
                                  'Start: ${startDateTime.toString()}, End: ${endDateTime.toString()}',
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueAzure),
                          ),
                        );
                        // move to new marker
                        _controller?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: position, zoom: 15),
                          ),
                        );
                      });

                      Navigator.of(context).pop(); // close dialog
                    } else {
                      // error handling here (user didn't fill everything out)
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<DateTime?> pickDateTime(DateTime? initialDateTime) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: profile(context),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: _markers,
        onLongPress: _onMapLongPress,
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, _selectedIndex),
    );
  }
}
