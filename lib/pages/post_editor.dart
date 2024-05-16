import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/firestore_methods.dart';

class PostEditorPage extends StatefulWidget {
  final Map<String, dynamic> eventDoc;
  final String eventId;
  final Uint8List initialFile;

  const PostEditorPage(
      {Key? key,
      required this.eventDoc,
      required this.eventId,
      required this.initialFile})
      : super(key: key);

  @override
  _PostEditorPageState createState() => _PostEditorPageState();
}

class _PostEditorPageState extends State<PostEditorPage> {
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _file = widget.initialFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (_isLoading) const CircularProgressIndicator(),
              TextField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(hintText: "Write a caption..."),
              ),
              const SizedBox(height: 10),
              _file != null
                  ? Image.memory(_file!)
                  : Container(
                      height: 200,
                      child: Center(child: Text("No image selected"))),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _file != null
                    ? postImageWithCurrentUserDetails
                    : null, // Disable button if no image is selected
                child: const Text("Post"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void postImageWithCurrentUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      var userData = userDoc.data();
      if (userData != null) {
        String uid = user.uid;
        String username = userData['username'] ?? 'Unknown Username';
        String firstName = userData['firstName'] ?? 'First';
        String lastName = userData['lastName'] ?? 'Last';
        String event = widget.eventDoc['title'] ?? 'Default Event';
        String pfpUrl = userData['profilePicturePath'] ??
            'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg';

        _postImage(uid, username, firstName, lastName, event, pfpUrl);
      } else {
        print("User data not found");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("User not logged in");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _postImage(String uid, String username, String firstName,
      String lastName, String event, String pfpUrl) async {
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        firstName,
        lastName,
        event,
        widget.eventId,
        pfpUrl,
      );
      if (res == "success") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Posted successfully!')));
        Navigator.pop(
            context); // Navigate back to the event detail page after successful posting
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
        _file = null; // Clear the selected file
        _descriptionController.clear(); // Clear the text field
      });
    }
  }
}
