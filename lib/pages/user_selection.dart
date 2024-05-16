import 'package:flutter/material.dart';
import './user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserSelectionPage extends StatefulWidget {
  final String eventId; 

  const UserSelectionPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _UserSelectionPageState createState() => _UserSelectionPageState();
}
class _UserSelectionPageState extends State<UserSelectionPage> {
  List<String> selectedUsers = [];
    bool _isSending = false;

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Users to Invite")),
      body: UserList(
        onSelected: (userId, isSelected) {
          setState(() {
            if (isSelected) {
              selectedUsers.add(userId);
            } else {
              selectedUsers.remove(userId);
            }
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isSending ? null : () async {
          setState(() {
            _isSending = true;
          });
          sendInvitations();
          Navigator.pop(context, selectedUsers);
        },
        child: _isSending ? CircularProgressIndicator(color: Colors.white) : Icon(Icons.check),
      ),
    );
  }

  void sendInvitations() async {
  var currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null || selectedUsers.isEmpty) return;
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic> ?? {};
    String username = userData['username'] ?? 'A User';

    for (var userId in selectedUsers) {
      await FirebaseFirestore.instance.collection('notifications').add({
        'receiverUID': userId,
        'senderUID': currentUser.uid,
        'title': 'Event Invitation',
        'message': '$username has invited you to an event.',
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'event_invitation',
        'eventId': widget.eventId,
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to send invitations: $e"))
    );
  }
}

}