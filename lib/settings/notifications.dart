import 'package:app/functions.dart';
import 'package:flutter/material.dart';
import 'package:app/settings/settings.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> {
  bool _notificationEnabled = true;
  bool _likes = true;
  bool _comments = true;
  // bool _shares = true;
  bool _eventUpdates = true;
  bool _newEventSuggestions = true;
  bool _eventReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:
            const Text('Notifications', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            newRoute(context, SettingsPage());
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Receive Notifications',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Switch(
                  value: _notificationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationEnabled = value;
                      if (value) {
                        // If main switch is turned on, turn on all sub-notifications
                        _likes = true;
                        _comments = true;
                        // _shares = true;
                        _eventUpdates = true;
                        _newEventSuggestions = true;
                        _eventReminders = true;
                      }
                    });
                  },
                  activeColor: Colors.white, // Thumb color when active
                  activeTrackColor: Colors.green, // Track color when active
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Post Notifications',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            buildSwitchListTile(
              title: 'Likes',
              subtitle: 'Receive notifications for likes',
              value: _likes,
              onChanged: _notificationEnabled
                  ? (value) {
                      setState(() {
                        _likes = value;
                      });
                    }
                  : null,
            ),
            buildSwitchListTile(
              title: 'Comments',
              subtitle: 'Receive notifications for comments',
              value: _comments,
              onChanged: _notificationEnabled
                  ? (value) {
                      setState(() {
                        _comments = value;
                      });
                    }
                  : null,
            ),
            // buildSwitchListTile(
            //   title: 'Shares',
            //   subtitle: 'Receive notifications for shares',
            //   value: _shares,
            //   onChanged: _notificationEnabled
            //       ? (value) {
            //           setState(() {
            //             _shares = value;
            //           });
            //         }
            //       : null,
            // ),
            const Text(
              'Event Notifications',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            buildSwitchListTile(
              title: 'Event Updates',
              subtitle: 'Receive updates about events',
              value: _eventUpdates,
              onChanged: _notificationEnabled
                  ? (value) {
                      setState(() {
                        _eventUpdates = value;
                      });
                    }
                  : null,
            ),
            buildSwitchListTile(
              title: 'New Event Suggestions',
              subtitle: 'Receive suggestions for new events',
              value: _newEventSuggestions,
              onChanged: _notificationEnabled
                  ? (value) {
                      setState(() {
                        _newEventSuggestions = value;
                      });
                    }
                  : null,
            ),
            buildSwitchListTile(
              title: 'Event Reminders',
              subtitle: 'Receive reminders for upcoming events',
              value: _eventReminders,
              onChanged: _notificationEnabled
                  ? (value) {
                      setState(() {
                        _eventReminders = value;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildSwitchListTile({
  required String title,
  required String subtitle,
  required bool value,
  required Function(bool)? onChanged,
}) {
  return SwitchListTile(
    title: Text(title, style: const TextStyle(color: Colors.white)),
    subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
    value: value,
    onChanged: onChanged,
    activeColor: Colors.white,
    activeTrackColor: Colors.green,
  );
}
