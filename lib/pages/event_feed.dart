import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../pages/post_card.dart';
import 'post_editor.dart';
import 'package:intl/intl.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/map');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _selectImage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: _buildEventDetails(),
          ),
          Expanded(
            flex: 3,
            child: _buildPostList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            tileColor: const Color.fromARGB(255, 22, 26, 37),
            title: Text(widget.eventDoc['title']),
            subtitle: Text(widget.eventDoc['description']),
          ),
          ListTile(
            tileColor: const Color.fromARGB(255, 22, 26, 37),
            leading: const Icon(Icons.location_on),
            title: Text(widget.eventDoc['address']),
          ),
          ListTile(
            tileColor: const Color.fromARGB(255, 22, 26, 37),
            leading: const Icon(Icons.calendar_today),
            title: Text(
                'Starts: ${DateFormat('hh:mm a MM/dd/yyyy').format(DateTime.parse(widget.eventDoc['startDateTime']))}'),
            subtitle: Text(
                'Ends: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(widget.eventDoc['endDateTime']))}'),
          ),
        ],
      ),
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
          return const Text("No posts available for this event.");
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) =>
              PostCard(snap: snapshot.data!.docs[index].data()),
        );
      },
    );
  }

  Future<void> _selectImage() async {
    final ImageSource? source = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Image'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Take a photo'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Choose from gallery'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
      }
    }
  }
}
