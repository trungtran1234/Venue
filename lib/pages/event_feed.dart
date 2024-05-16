import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../pages/post_card.dart';
import 'post_editor.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> eventDoc;
  final String eventId;

  const EventDetailPage(
      {Key? key, required this.eventDoc, required this.eventId})
      : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    bool isUserEventOwner = _auth.currentUser?.uid == widget.eventDoc['userId'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isUserEventOwner)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteEvent,
            ),
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: _selectImage,
          ),
        ],
      ),
      body: _buildEventDetailContent(),
    );
  }

  Widget _buildEventDetailContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildEventDetails(),
          _buildPostList(),
        ],
      ),
    );
  }

  Widget _buildEventDetails() {
    return Column(
      children: [
        ListTile(
          tileColor: const Color.fromARGB(255, 22, 26, 37),
          title: Text(widget.eventDoc['title'],
              style: const TextStyle(fontSize: 26)),
          subtitle: Text(widget.eventDoc['description'],
              style: const TextStyle(fontSize: 18)),
        ),
        ListTile(
          tileColor: const Color.fromARGB(255, 22, 26, 37),
          leading: Icon(Icons.location_on),
          title: Text(widget.eventDoc['address']),
        ),
        ListTile(
          tileColor: const Color.fromARGB(255, 22, 26, 37),
          leading: Icon(Icons.calendar_today),
          title: Text(
              'Starts: ${DateFormat('hh:mm a MM/dd/yyyy').format(DateTime.parse(widget.eventDoc['startDateTime']))}'),
          subtitle: Text(
              'Ends: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(widget.eventDoc['endDateTime']))}'),
        ),
      ],
    );
  }

  Widget _buildPostList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('eventId', isEqualTo: widget.eventId)
          .orderBy('datePublished', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No posts available for this event.");
        }
        return ListView.builder(
          shrinkWrap: true,
          physics:
              NeverScrollableScrollPhysics(), // Prevents the ListView itself from scrolling
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) =>
              PostCard(snap: snapshot.data!.docs[index].data()),
        );
      },
    );
  }

  Future<void> _selectImage() async {
    Position currentPosition;
    try {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get location: ${e.toString()}')));
      return;
    }

    double eventLat = widget.eventDoc['latitude'];
    double eventLng = widget.eventDoc['longitude'];

    double distanceInMeters = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        eventLat,
        eventLng);

    if (distanceInMeters > 1609) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Too Far Away"),
          content:
              Text("You must be within 1 mile of the event to create a post."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('Select Image'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: Text('Take a photo'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: Text('Choose from gallery'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      );

      if (source != null) {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          final Uint8List file = await image.readAsBytes();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostEditorPage(
                  eventId: widget.eventId,
                  eventDoc: widget.eventDoc,
                  initialFile: file),
            ),
          );
          _appendToPosterList(widget.eventId, _auth.currentUser!.uid);
        }
      }
    }
  }

  Future<void> _appendToPosterList(String eventId, String userId) async {
    await FirebaseFirestore.instance.collection('events').doc(eventId).update({
      'poster_list': FieldValue.arrayUnion([userId])
    });
  }

  void _deleteEvent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this event?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                FirebaseFirestore.instance
                    .collection('events')
                    .doc(widget.eventId)
                    .delete()
                    .then((_) {
                  Navigator.pushNamed(context, '/map');
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting event: $error')));
                });
              },
            ),
          ],
        );
      },
    );
  }
}
