import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../pages/post_card.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';
import '../database/firestore_methods.dart';

class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> eventDoc;
  final String eventId;

  const EventDetailPage({Key? key, required this.eventDoc, required this.eventId}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: _selectImage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _buildEventDetails(),
          ),
          Expanded(
            flex: 3,
            child: _buildPostList(),
          ),
          if (_file != null) _buildPostEditor(),
        ],
      ),
    );
  }

  Widget _buildEventDetails() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.eventDoc['title']),
            subtitle: Text(widget.eventDoc['description']),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text(widget.eventDoc['address']),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Starts: ${widget.eventDoc['startDateTime']}'),
            subtitle: Text('Ends: ${widget.eventDoc['endDateTime']}'),
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
              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No posts available for this event.");
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) => PostCard(snap: snapshot.data!.docs[index].data()),
        );
      },
    );
  }

  Widget _buildPostEditor() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (_isLoading) const CircularProgressIndicator(),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: "Write a caption..."),
          ),
          SizedBox(height: 10),
          _file != null ? Image.memory(_file!) : Container(),
          ElevatedButton(
            onPressed: () => _postImage("test_id", "test_user"),
            child: Text("Post"),
          ),
        ],
      ),
    );
  }

  Future<void> _selectImage() async {
    final ImageSource? source = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Create a Post'),
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
        setState(() {
          _file = file;
        });
      }
    }
  }

  void _postImage(String uid, String username) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        widget.eventId,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
          _file = null;
          _descriptionController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Posted successfully!')));
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
