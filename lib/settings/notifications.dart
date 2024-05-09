import 'package:flutter/material.dart';
import 'package:app/global.dart';
import 'package:app/settings/settings.dart';
import 'package:app/services/preferences.dart';

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
  bool _isLoading = true; // Add a loading state indicator

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
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _notificationEnabled = await PreferencesService()
        .getBool('notificationEnabled', defaultValue: true);
    await _loadNotificationOptions(postNotifications);
    await _loadNotificationOptions(eventNotifications);
    await _loadNotificationOptions(friendNotifications);
    if (mounted) {
      setState(() {
        _isLoading = false; // Set loading to false after settings are loaded
      });
    }
  }

  Future<void> _loadNotificationOptions(
      List<NotificationOption> options) async {
    for (var option in options) {
      String key = '${option.title.replaceAll(' ', '')}';
      bool value =
          await PreferencesService().getBool(key, defaultValue: option.value);
      option.value = value;
    }
  }

  void _updateSetting(NotificationOption option, bool value) {
    PreferencesService().setBool(option.title.replaceAll(' ', ''), value);
    setState(() {
      option.value = value;
    });
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text('Receive Push Notifications',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    value: _notificationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationEnabled = value;
                        PreferencesService()
                            .setBool('notificationEnabled', value);
                        for (var option in postNotifications) {
                          _updateSetting(option, value);
                        }
                        for (var option in eventNotifications) {
                          _updateSetting(option, value);
                        }
                        for (var option in friendNotifications) {
                          _updateSetting(option, value);
                        }
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  ...buildNotificationSection(
                      'Post Notifications', postNotifications),
                  ...buildNotificationSection(
                      'Event Notifications', eventNotifications),
                  ...buildNotificationSection(
                      'Friend Notifications', friendNotifications),
                ],
              ),
            ),
    );
  }

  List<Widget> buildNotificationSection(
      String title, List<NotificationOption> options) {
    return [
      Text(title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 10),
      ...options
          .map((option) => SwitchListTile(
                title: Text(option.title,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(option.subtitle,
                    style: const TextStyle(color: Colors.grey)),
                value: option.value,
                onChanged: _notificationEnabled
                    ? (newValue) {
                        _updateSetting(option, newValue);
                      }
                    : null,
                activeColor: Colors.white,
                activeTrackColor: Colors.green,
              ))
          .toList(),
    ];
  }
}
