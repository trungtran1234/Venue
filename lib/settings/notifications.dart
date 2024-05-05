import 'package:app/global.dart';
import 'package:flutter/material.dart';
import 'package:app/settings/settings.dart';

class NotificationOption {
  String title;
  String subtitle;
  bool value;

  NotificationOption({
    required this.title,
    required this.subtitle,
    required this.value,
  });
}

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> {
  bool _notificationEnabled = true;
  List<NotificationOption> postNotifications = [
    NotificationOption(
        title: 'Likes',
        subtitle: 'Receive notifications for likes',
        value: true),
    NotificationOption(
        title: 'Comments',
        subtitle: 'Receive notifications for comments',
        value: true),
  ];

  List<NotificationOption> eventNotifications = [
    NotificationOption(
        title: 'Event Updates',
        subtitle: 'Receive updates about events',
        value: true),
    NotificationOption(
        title: 'New Event Suggestions',
        subtitle: 'Receive suggestions for new events',
        value: true),
    NotificationOption(
        title: 'Event Reminders',
        subtitle: 'Receive reminders for upcoming events',
        value: true),
  ];

  List<NotificationOption> friendNotifications = [
    NotificationOption(
        title: 'Friend Requests',
        subtitle: 'Receive notifications for friend requests',
        value: true),
    NotificationOption(
        title: 'Friend Activity',
        subtitle: 'Receive notifications when friends post or update events',
        value: true),
  ];

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
                const Text('Receive Notifications',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Switch(
                  value: _notificationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationEnabled = value;
                      for (var option in postNotifications) {
                        option.value = value;
                      }
                      for (var option in eventNotifications) {
                        option.value = value;
                      }
                      for (var option in friendNotifications) {
                        option.value = value;
                      }
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                )
              ],
            ),
            const SizedBox(height: 20),
            buildNotificationSection('Post Notifications', postNotifications),
            buildNotificationSection('Event Notifications', eventNotifications),
            buildNotificationSection(
                'Friend Notifications', friendNotifications),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationSection(
      String title, List<NotificationOption> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 10),
        ...options.map((option) => buildSwitchListTile(option)).toList(),
      ],
    );
  }

  Widget buildSwitchListTile(NotificationOption option) {
    return SwitchListTile(
      title: Text(option.title, style: const TextStyle(color: Colors.white)),
      subtitle:
          Text(option.subtitle, style: const TextStyle(color: Colors.grey)),
      value: option.value,
      onChanged: _notificationEnabled
          ? (newValue) {
              setState(() => option.value = newValue);
            }
          : null,
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
    );
  }
}
