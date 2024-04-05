import 'package:flutter/material.dart';
import 'package:app/pages/profile.dart';
import 'package:app/pages/friends.dart';
import 'package:app/pages/newsfeed.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _selectedIndex = 1;

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(40.730610, -73.935242), //random coords for now
    zoom: 11.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: profile(context),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal, //map style
        onMapCreated: (GoogleMapController controller) { //need controller for interactions later
        },
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
