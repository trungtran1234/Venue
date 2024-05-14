import 'dart:typed_data';
import 'package:app/database/firestore_methods.dart';
import 'package:app/global.dart';
import 'package:app/pages/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';
import '../main.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeedPage> {
  final int _selectedIndex = 0;
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  final ConnectivityChecker _connectivityChecker = ConnectivityChecker();
  final PopupManager _popupManager = PopupManager();

  @override
  void initState() {
    super.initState();
    _connectivityChecker.onStatusChanged = _handleConnectivityChange;
  }

  void _handleConnectivityChange(bool isConnected) {
    if (!isConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _popupManager.showConnectivityPopup(context);
      });
    } else {
      _popupManager.dismissConnectivityPopup();
    }
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
      final Uint8List file = await pickImage(source);
      setState(() => _file = file);
    }
  }

  void _postImage(String uid, String username) async {
    setState(() => _isLoading = true);
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
      );
      setState(() => _isLoading = false);
      showTopSnackBar(
        context,
        res == "success" ? 'Posted!' : res,
        backgroundColor: res == "success" ? Colors.green : Colors.red,
      );
      if (res == "success") clearImage();
    } catch (e) {
      showTopSnackBar(context, e.toString());
    }
  }

  void clearImage() => setState(() => _file = null);

  @override
  void dispose() {
    _descriptionController.dispose();
    _connectivityChecker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Ensuring AppBar blends with the gradient
        title: const Text('News Feed', style: TextStyle(color: Colors.white)),
        elevation: 0, // Remove shadow from AppBar
        actions: [
          if (_file == null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _selectImage,
            ),
        ],
      ),
      body: _file == null ? _buildPostList() : _buildPostEditor(),
      bottomNavigationBar: buildBottomNavigationBar(context, _selectedIndex),
    );
  }

  Widget _buildPostList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) =>
              PostCard(snap: snapshot.data!.docs[index].data()),
        );
      },
    );
  }

  Widget _buildPostEditor() {
    return Column(
      children: [
        if (_isLoading) const LinearProgressIndicator(),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('lib/assets/Default_pfp.svg.png'), // Update your default image path as necessary
            ),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                ),
                maxLines: 8,
              ),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: AspectRatio(
                aspectRatio: 487 / 451,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(_file!),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () => _postImage("test_id", "test_user"),
          child: const Text('Post',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
      ],
    );
  }
}