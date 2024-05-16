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
import './event_feed.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

enum EventVisibility { public, friendsOnly }

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
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  BitmapDescriptor? _customMarker;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    preloadUserDetails().then((_) {
      loadCustomMarker().then((_) {
        _loadEvents();
      });
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

  Future<void> loadCustomMarker() async {
    try {
      final byteData = await rootBundle.load('lib/assets/logo.png');
      final buffer = byteData.buffer;
      List<int> imgList =
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      Uint8List imgBytes = Uint8List.fromList(imgList);
      img.Image? image = img.decodeImage(imgBytes);
      img.Image resized = img.copyResize(image!, width: 100, height: 170);

      Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resized));
      _customMarker = BitmapDescriptor.fromBytes(resizedBytes);
    } catch (e) {
      print("Failed to load custom marker: $e");
    }
  }

  Future<String> getPlaceAddress(double latitude, double longitude) async {
    const apiKey = 'AIzaSyBuznTrerLg81eCkcf5AcPAGXpdStMuIh8';
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
    final user = FirebaseAuth.instance.currentUser;
    List<String> friendsList = [];

    if (user != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists && userDoc.data()!.containsKey('friends')) {
        friendsList = List<String>.from(userDoc.data()!['friends']);
      }
    }

    FirebaseFirestore.instance
        .collection('events')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      var newMarkers = <Marker>{};
      for (var doc in snapshot.docs) {
        double lat = doc.data()['latitude'];
        double lng = doc.data()['longitude'];
        String eventVisibility = doc.data()['visibility'];
        String eventCreatorId = doc.data()['userId'];
        Map<String, dynamic>? hostData = userCache[eventCreatorId];

        bool shouldDisplay = false;

        if (eventCreatorId == user?.uid ||
            eventVisibility == 'public' ||
            (eventVisibility == 'friendsOnly' &&
                friendsList.contains(eventCreatorId))) {
          shouldDisplay = true;
        }

        if (shouldDisplay) {
          var markerId = MarkerId(doc.id);
          var marker = Marker(
            markerId: markerId,
            position: LatLng(lat, lng),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 29, 38, 60),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              hostData != null ? CircleAvatar(
                              backgroundImage: NetworkImage(hostData['profilePicturePath']),
                              radius: 20,
                            ) : Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                              Text(
                                doc.data()['firstName'] +
                                    ' ' +
                                    doc.data()['lastName'] +
                                    ' @' +
                                    doc.data()['username'],
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              SizedBox(
                                height: 13.0,
                              ),
                              Text(
                                doc.data()['title'],
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              
                              SizedBox(height: 10),
                              Text(
                                doc.data()['address'],
                                textAlign:
                                    TextAlign.center, // Center align the text
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'From: ${DateFormat('hh:mm a MM/dd/yyyy').format(DateTime.parse(doc.data()['startDateTime']).toLocal())}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                              ),
                              Text(
                                'To: ${DateFormat(' hh:mm a MM/dd/yyyy').format(DateTime.parse(doc.data()['endDateTime']).toLocal())}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        color: Colors.white, fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${doc.data()['visibility'] == 'friendsOnly' ? 'Friends Only' : 'Public'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  _customInfoWindowController.hideInfoWindow!();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailPage(
                                          eventDoc: doc.data(),
                                          eventId: doc.id),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Color.fromARGB(255, 13, 16, 33),
                                  backgroundColor: Color.fromARGB(
                                      255, 208, 157, 38), // Text color
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8), // Adjust the padding
                                  shape: RoundedRectangleBorder(
                                    // Optional: if you want rounded corners
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text('View Details'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Triangle.isosceles(
                      edge: Edge.BOTTOM,
                      child: Container(
                        color: const Color.fromARGB(255, 29, 38, 60),
                        width: 20.0,
                        height: 10.0,
                      ),
                    ),
                  ],
                ),
                LatLng(lat, lng),
              );
            },
            icon: _customMarker ?? BitmapDescriptor.defaultMarker,
          );
          newMarkers.add(marker);
        }
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
    EventVisibility visibility = EventVisibility.public;

    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController errorController = TextEditingController();

    final List<DropdownMenuItem<EventVisibility>> dropdownItems = [
      DropdownMenuItem(value: EventVisibility.public, child: Text('Public')),
      DropdownMenuItem(
          value: EventVisibility.friendsOnly, child: Text('Friends Only')),
    ];
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if the user already has an active event
      var existingEvent = await FirebaseFirestore.instance
          .collection('events')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();
      if (existingEvent.docs.isNotEmpty) {
        // User already has an event
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("You already have an active event"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
        return; // Exit the function if the user already has an event
      }
    }

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
                    decoration: InputDecoration(labelText: 'Title'),
                    maxLines: null,
                    minLines: 1,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: null,
                    minLines: 1,
                  ),
                  Flexible(
                    child: TextFormField(
                        initialValue: address,
                        readOnly: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Location',
                        )),
                  ),
                  ListTile(
                    title: Text('Select Start Date and Time'),
                    subtitle: Text(selectedStartDate == null
                        ? 'No date and time chosen'
                        : DateFormat('hh:mm a MM/dd/yyyy')
                            .format(selectedStartDate!)),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final TimeOfDay? time = await showTimePicker(
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
                            errorController.clear();
                          });
                        }
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Select End Date and Time'),
                    subtitle: Text(selectedEndDate == null
                        ? 'No date and time chosen'
                        : DateFormat('hh:mm a MM/dd/yyyy')
                            .format(selectedEndDate!)),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (selectedStartDate == null) {
                        errorController.clear();
                        errorController.text =
                            "Please select a start date first.";
                        return;
                      }
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: selectedStartDate!,
                        firstDate: selectedStartDate!,
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          DateTime tempEndDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          if (tempEndDate.isBefore(selectedStartDate!)) {
                            errorController.clear();
                            errorController.text =
                                "End date must be after the start date.";
                          } else {
                            setState(() {
                              selectedEndDate = tempEndDate;
                              errorController.clear();
                            });
                          }
                        }
                      }
                    },
                  ),
                  DropdownButton<EventVisibility>(
                    value: visibility,
                    onChanged: (EventVisibility? newValue) {
                      setState(() {
                        visibility = newValue!;
                        errorController.clear();
                      });
                    },
                    items: dropdownItems,
                  ),
                  TextField(
                    controller: errorController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                        color: errorController.text.isEmpty
                            ? Colors.transparent
                            : Colors.red),
                  )
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    selectedStartDate == null ||
                    selectedEndDate == null) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  errorController.clear();
                  errorController.text = "Please fill in all fields.";
                } else {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  Navigator.of(context).pop();
                  _addMarker(
                      position, address, selectedStartDate, selectedEndDate);
                  _saveEventToFirestore(
                      position,
                      titleController.text,
                      descriptionController.text,
                      address,
                      selectedStartDate,
                      selectedEndDate,
                      visibility);
                }
              },
              child: const Text('Submit')),
        ],
      ),
    );
  }

  void _saveEventToFirestore(
      LatLng position,
      String title,
      String description,
      String address,
      DateTime? startDateTime,
      DateTime? endDateTime,
      EventVisibility visibility) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, dynamic> userDetails = userCache[user.uid] ?? {};
      if (userDetails.isEmpty) {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          userDetails = userDoc.data()!;
          userCache[user.uid] = userDetails;
        }
      }

      String username = userDetails['username'] ?? 'Unknown';
      String firstName = userDetails['firstName'] ?? 'Unknown';
      String lastName = userDetails['lastName'] ?? 'Unknown';

      DocumentReference eventRef =
          FirebaseFirestore.instance.collection('events').doc();

      await eventRef.set({
        'id': eventRef.id,
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
        'visibility': visibility.toString().split('.').last,
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
                  initialCameraPosition:
                      CameraPosition(target: currentPosition!, zoom: 17),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    _customInfoWindowController.googleMapController =
                        controller;
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
            height: 320,
            width: 420,
            offset: 50,
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 1),
    );
  }
}
