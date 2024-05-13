import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';
import 'package:app/global.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  final int _selectedIndex = 2;
  late ConnectivityChecker connectivityChecker;
  late PopupManager popupManager;

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

  @override
  void dispose() {
    connectivityChecker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            const Text('Notifications', style: TextStyle(color: Colors.white)),
      ),
      body: notificationsList(context),
      bottomNavigationBar: buildBottomNavigationBar(context, _selectedIndex),
    );
  }

  Widget notificationsList(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Text("You need to be logged in to view notifications.");
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .where('receiverUID', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No notifications.');
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var notification =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return ListTile(
              leading:
                  const Icon(Icons.notification_important, color: Colors.blue),
              title: Text(notification['title'],
                  style: const TextStyle(fontSize: 16)),
              subtitle: Text(notification['message'],
                  style: TextStyle(color: Colors.grey[600])),
              onTap: () => handleNotificationTap(
                  notification, snapshot.data!.docs[index].id),
            );
          },
        );
      },
    );
  }

  void handleNotificationTap(Map<String, dynamic> data, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Friend Request"),
          content: Text("${data['sender']} wants to add you as a friend."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                updateFriendRequestStatus(docId, true);
                Navigator.of(context).pop();
              },
              child: const Text("Accept"),
            ),
            TextButton(
              onPressed: () {
                updateFriendRequestStatus(docId, false);
                Navigator.of(context).pop();
              },
              child: const Text("Decline"),
            ),
          ],
        );
      },
    );
  }

  void updateFriendRequestStatus(String docId, bool accepted) {
    if (accepted) {
      FirebaseFirestore.instance
          .collection('notifications')
          .doc(docId)
          .get()
          .then((doc) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String senderUID =
              data['senderUID']; // Correctly retrieve sender's UID
          String receiverUID = FirebaseAuth.instance.currentUser!.uid;

          // Add each user's UID to the other's friends list
          FirebaseFirestore.instance
              .collection('users')
              .doc(receiverUID)
              .update({
            'friends': FieldValue.arrayUnion([senderUID])
          });
          FirebaseFirestore.instance.collection('users').doc(senderUID).update({
            'friends': FieldValue.arrayUnion([receiverUID])
          });
        }
      }).whenComplete(() {
        FirebaseFirestore.instance
            .collection('notifications')
            .doc(docId)
            .delete()
            .then((_) {
          showTopSnackBar(
            context,
            'Friend request accepted',
            backgroundColor: Colors.green,
          );
        }).catchError((error) {
          showTopSnackBar(
            context,
            'Error updating request: $error',
            backgroundColor: Colors.red,
          );
        });
      });
    } else {
      // Just delete the notification if declined
      FirebaseFirestore.instance
          .collection('notifications')
          .doc(docId)
          .delete();
    }
  }
}
