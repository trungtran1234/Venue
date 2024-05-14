import 'package:flutter/material.dart';
import 'package:app/global.dart';
import 'package:app/settings/settings.dart';
import 'package:app/services/preferences.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  ActivityPageState createState() => ActivityPageState();
}

class ActivityPageState extends State<ActivityPage> {
  bool? _showLikes;
  bool? _showShares;
  bool? _showComments;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActivitySettings();
  }

  Future<void> _loadActivitySettings() async {
    _showLikes =
        await PreferencesService().getBool('showLikes', defaultValue: true);
    _showShares =
        await PreferencesService().getBool('showShares', defaultValue: true);
    _showComments =
        await PreferencesService().getBool('showComments', defaultValue: true);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateActivitySetting(String key, bool value) async {
    await PreferencesService().setBool(key, value);
    if (key == 'showLikes')
      _showLikes = value;
    else if (key == 'showShares')
      _showShares = value;
    else if (key == 'showComments') _showComments = value;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Activity Settings',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            newRoute(context, SettingsPage());
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSwitchListTile(
                      'Show Likes',
                      'Display your likes on friends\' posts',
                      _showLikes ?? true,
                      'showLikes'),
                  _buildSwitchListTile(
                      'Show Shares',
                      'Display your shares on friends\' posts',
                      _showShares ?? true,
                      'showShares'),
                  _buildSwitchListTile(
                      'Show Comments',
                      'Display your comments on friends\' posts',
                      _showComments ?? true,
                      'showComments'),
                ],
              ),
            ),
    );
  }

  Widget _buildSwitchListTile(
      String title, String subtitle, bool value, String key) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      value: value,
      onChanged: (newValue) => _updateActivitySetting(key, newValue),
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
    );
  }
}
