import 'dart:convert';
import 'package:app/global.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:clippy_flutter/triangle.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage>
    with AutomaticKeepAliveClientMixin<MapPage> {
  GoogleMapController? _controller;
  final Location _location = Location();
  Set<Marker> _markers = {};
  LatLng? currentPosition;
  Map<String, Map<String, dynamic>> userCache = {};
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    preloadUserDetails().then((_) {
      _loadEvents();
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _location.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() => currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!));
      }
    });
  }

  Future<String> getPlaceAddress(double latitude, double longitude) async {
    const apiKey = 'key';
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

  Future<void> preloadUserDetails() async {
    var events = await FirebaseFirestore.instance.collection('events').get();
    var userIds =
        events.docs.map((doc) => doc.data()['userId'] as String).toSet();

    await Future.forEach<String>(userIds, (userId) async {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        userCache[userId] = userDoc.data() as Map<String, dynamic>;
      }
    });
  }


  void _loadEvents() async {
    FirebaseFirestore.instance
      .collection('events')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .listen((snapshot) {
        var newMarkers = <Marker>{};
        for (var doc in snapshot.docs) {
          double lat = doc.data()['latitude'];
          double lng = doc.data()['longitude'];
          var markerId = MarkerId(doc.id);

          var marker = Marker(
            markerId: markerId,
            position: LatLng(lat, lng),
            onTap: () {
              // Constructing detailed and styled custom info window
              _customInfoWindowController.addInfoWindow!(
                Column(
                children: [
                  Expanded(
                    child: Container( 
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 4.0, 0), // Adjust the padding here
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                          
                            Text(
                              doc.data()['firstName'] + ' ' + doc.data()['lastName'] + ' @' + doc.data()['username'],
                              style:
                                  Theme.of(context).textTheme.headline6?.copyWith(
                                        color: Colors.white,
                                      ),
                            ),
                              SizedBox(
                              height: 8.0, // Adjust the height here
                            ),
                            Text(
                              doc.data()['title'],
                              style:
                                  Theme.of(context).textTheme.headline6?.copyWith(
                                        color: Colors.white,
                                      ),
                            ),
                            Text(
                              doc.data()['description'],
                              style:
                                  Theme.of(context).textTheme.headline6?.copyWith(
                                        color: Colors.white,
                            )
                            ),
                            Text(
                              doc.data()['address'],
                              style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              ),
                            ),
                              Text(
                              'From: ${DateFormat('hh:mm a MM/dd/yyyy').format(DateTime.parse(doc.data()['startDateTime']).toLocal())}',
                              style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    fontSize: 14, // Adjust the font size here
                                  ),
                              ),
                              Text(
                              'To: ${DateFormat(' hh:mm a MM/dd/yyyy').format(DateTime.parse(doc.data()['endDateTime']).toLocal())}',
                              style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    fontSize: 14, // Adjust the font size here
                                  ),
                              ),
                          
                          ],
                        ),
                      ),
                    ),
                  ),
                  Triangle.isosceles(
                    edge: Edge.BOTTOM,
                    child: Container(
                      color: Colors.blue,
                      width: 20.0,
                      height: 10.0,
                    ),
                  ),
                ],
              ),
                LatLng(lat, lng),
              );
            },
            icon: BitmapDescriptor.defaultMarker,
          );
          newMarkers.add(marker);
        }
        setState(() => _markers = newMarkers);
      });
  }

  void _addMarker(LatLng position, String address, DateTime? startDateTime,
      DateTime? endDateTime) {
    setState(() {
      final Marker marker = Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
            title: 'Event Location',
            snippet:
                'Starts: ${DateFormat('yyyy-MM-dd kk:mm').format(startDateTime!)} Ends: ${DateFormat('yyyy-MM-dd kk:mm').format(endDateTime!)} Address: $address'),
        icon: BitmapDescriptor.defaultMarker,
      );
      _markers.add(marker);
    });
  }

  void _onMapLongPress(LatLng position) async {
    String address =
        await getPlaceAddress(position.latitude, position.longitude);
    DateTime? selectedStartDate;
    DateTime? selectedEndDate;

    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Event'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title')),
                  TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description')),
                  TextFormField(initialValue: address, readOnly: true),
                  ListTile(
                    title: Text('Select Start Date and Time'),
                    subtitle: Text(selectedStartDate == null
                        ? 'No date and time chosen'
                        : DateFormat('yyyy-MM-dd – kk:mm')
                                .format(selectedStartDate!) +
                            ' hrs'),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            selectedStartDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Select End Date and Time'),
                    subtitle: Text(selectedEndDate == null
                        ? 'No date and time chosen'
                        : DateFormat('yyyy-MM-dd – kk:mm')
                                .format(selectedEndDate!) +
                            ' hrs'),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedStartDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            selectedEndDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addMarker(
                    position, address, selectedStartDate, selectedEndDate);
                _saveEventToFirestore(
                    position,
                    titleController.text,
                    descriptionController.text,
                    address,
                    selectedStartDate,
                    selectedEndDate);
              },
              child: const Text('Submit')),
        ],
      ),
    );
  }

void _saveEventToFirestore(LatLng position, String title, String description,
    String address, DateTime? startDateTime, DateTime? endDateTime) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Fetch user details from the cache or Firestore
    Map<String, dynamic> userDetails = userCache[user.uid] ?? {};

    // Fetch from Firestore if not in cache
    if (userDetails.isEmpty) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        userDetails = userDoc.data()!;
        userCache[user.uid] = userDetails; // Cache it for future use
      }
    }

    // Extract the required user details
    String username = userDetails['username'] ?? 'Unknown'; // Make sure the key matches your database
    String firstName = userDetails['firstName'] ?? 'Unknown';
    String lastName = userDetails['lastName'] ?? 'Unknown';

    // Now add these details along with the event details to Firestore
    FirebaseFirestore.instance.collection('events').add({
      'userId': user.uid,
      'userEmail': user.email,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'title': title,
      'description': description,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
      'startDateTime': startDateTime?.toIso8601String(),
      'endDateTime': endDateTime?.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

 @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Discover', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(target: currentPosition!, zoom: 17),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  _customInfoWindowController.googleMapController = controller;
                },
                markers: _markers.toSet(),
                onTap: (LatLng latLng) {
                  _customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (CameraPosition position) {
                  _customInfoWindowController.onCameraMove!();
                },
                onLongPress: _onMapLongPress,
              ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 360,
            width: 420,
            offset: 60,
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 1), // Assuming you have this function
    );
  }
}
