import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class UserList extends StatefulWidget {
  final Function(String, bool) onSelected;

  UserList({Key? key, required this.onSelected}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final List<String> _selectedUsers = [];
  List<String> friendIds = [];

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  void fetchFriends() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists && userDoc.data()!.containsKey('friends')) {
        setState(() {
          friendIds = List<String>.from(userDoc.data()!['friends']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (friendIds.isEmpty) {
      return Center(child: Text("No friends found."));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: friendIds)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No friends found."));
        }

        var docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var user = docs[index];
            var userId = user.id;
            var isSelected = _selectedUsers.contains(userId);

            return ListTile(
              title: Text((user.data() as Map<String, dynamic>)['username'] ?? 'No name provided'),
              trailing: isSelected
                  ? Icon(Icons.check_box)
                  : Icon(Icons.check_box_outline_blank),
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedUsers.remove(userId);
                    widget.onSelected(userId, false);
                  } else {
                    _selectedUsers.add(userId);
                    widget.onSelected(userId, true);
                  }
                });
              },
            );
          },
        );
      },
    );
  }
}
