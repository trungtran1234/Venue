import 'dart:typed_data';

import 'package:app/database/firestore_methods.dart';
import 'package:app/pages/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/functions.dart';
import 'package:image_picker/image_picker.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  NewsFeedState createState() => NewsFeedState();
}

class NewsFeedState extends State<NewsFeedPage> {
  Uint8List? _file;
  final int _selectedIndex = 0;

  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  late ConnectivityChecker connectivityChecker;
  late PopupManager popupManager;

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
                setState(
                  () {
                    _file = file;
                  },
                );
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallary'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.gallery,
                );
                setState(
                  () {
                    _file = file;
                  },
                );
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    popupManager = PopupManager();
    connectivityChecker = ConnectivityChecker(
      onStatusChanged: onConnectivityChanged,
    );
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

  void postImage(String uid, String username) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
      );

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted!', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    connectivityChecker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: profile(context),
              actions: [
                IconButton(
                  onPressed: () => {_selectImage(context)},
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              },
            ),
            bottomNavigationBar:
                buildBottomNavigationBar(context, _selectedIndex),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Post To'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => postImage("test_id", "test_user"),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(
                  color: Color(0x00000000),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundImage:
                          AssetImage('lib/assets/Default_pfp.svg.png'),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
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
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
