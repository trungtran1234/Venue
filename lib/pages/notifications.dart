import 'package:app/global.dart';
import 'package:flutter/material.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  final int _selectedIndex =
      2; // Assuming Notifications is the fourth item in your BottomNavBar

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
        backgroundColor: Colors.transparent,
        title:
            const Text('Notifications', style: TextStyle(color: Colors.white)),
      ),
      body: notificationsList(context),
      bottomNavigationBar: buildBottomNavigationBar(context, _selectedIndex),
    );
  }

  Container notificationsList(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: 10, // Simulate 10 notifications
        itemBuilder: (context, index) {
          return ListTile(
            leading:
                const Icon(Icons.notification_important, color: Colors.blue),
            title: Text('Notification ${index + 1}',
                style: TextStyle(fontSize: 16)),
            subtitle: Text('Details about notification ${index + 1}',
                style: TextStyle(color: Colors.grey[600])),
            onTap: () {
              // Handle tap on each notification
            },
          );
        },
      ),
    );
  }
}
