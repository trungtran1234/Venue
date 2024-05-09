import 'package:flutter/material.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';
import 'package:app/global.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  late ConnectivityChecker connectivityChecker;
  late PopupManager popupManager;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchResults = [];
  final List<String> _friendsList = [
    'Friend 1',
    'Friend 2',
    'Friend 3',
    'Friend 4',
    'Friend 5',
  ];

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              // Handle the action for the icon on the right side
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _searchResults.isNotEmpty
                ? _buildSearchResults()
                : _buildFriendsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by username',
          suffixIcon: IconButton(
            onPressed: () {
              // Clear search input
              _searchController.clear();
              setState(() {
                _searchResults.clear();
              });
            },
            icon: const Icon(Icons.clear),
          ),
        ),
        onChanged: (query) {
          _performSearch(query);
        },
      ),
    );
  }

  void _performSearch(String query) {
    setState(() {
      _searchResults.clear();
      if (query.isNotEmpty) {
        _searchResults.addAll([
          'User 1',
          'User 2',
          'User 3',
        ]);
      }
    });
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final username = _searchResults[index];
        return ListTile(
          title: Text(username),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addFriend(username);
            },
          ),
        );
      },
    );
  }

  Widget _buildFriendsList() {
    return ListView.builder(
      itemCount: _friendsList.length,
      itemBuilder: (context, index) {
        final friendName = _friendsList[index];
        return ListTile(
          title: Text(friendName),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'invite',
                child: ListTile(
                  title: const Text('Invite'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<String>(
                value: 'unfriend',
                child: ListTile(
                  title: const Text('Unfriend'),
                  onTap: () {
                    _unfriend(friendName);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addFriend(String username) {
    showTopSnackBar(
      context,
      'Friend request sent to $username',
      backgroundColor: Colors.green,
    );
  }

  void _unfriend(String friendName) {
    showTopSnackBar(
      context,
      'Unfriended $friendName',
      backgroundColor: Colors.orange,
    );
  }
}
