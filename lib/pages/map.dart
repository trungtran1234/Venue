import 'package:flutter/material.dart';
import 'package:app/pages/profile.dart';
import 'package:app/pages/friends.dart';
import 'package:app/pages/newsfeed.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _selectedIndex = 1;
  GoogleMapController? _controller;
  Location _location = Location(); 
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 12.0,  
          ),
        ),
      );

    
      setState(() {
        _markers = {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
            infoWindow: InfoWindow(
              title: 'Your Location',
            ),
          ),
        };
      });
    });
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
      initialCameraPosition: CameraPosition(target: LatLng(0, 0)), 
      myLocationEnabled: true, 
      myLocationButtonEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
      markers: _markers,
    ),
    bottomNavigationBar: buildBottomNavigationBar(context, _selectedIndex),
  );
}
}

IconButton profile(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    },
    icon: const Icon(Icons.person),
  );
}

BottomNavigationBar buildBottomNavigationBar(
    BuildContext context, int selectedIndex) {
  return BottomNavigationBar(
    backgroundColor: Colors.white,
    currentIndex: selectedIndex,
    selectedItemColor: Colors.blue,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.newspaper),
        label: 'Feed',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: 'Map',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.group),
        label: 'Friends',
      ),
    ],
    onTap: (index) {
      _onItemTapped(context, index);
    },
  );
}

void _onItemTapped(BuildContext context, int index) {
  if (index == 0) {
    newRoute(context, const NewsFeedPage());
  } else if (index == 1) {
    newRoute(context, const MapPage());
  } else {
    newRoute(context, const FriendsPage());
  }
}

void newRoute(BuildContext context, Widget newRoute) {
  if (!Navigator.of(context).canPop()) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => newRoute));
  } else {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => newRoute));
  }
}
