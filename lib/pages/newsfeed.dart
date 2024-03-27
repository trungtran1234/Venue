import 'package:flutter/material.dart';
import 'package:app/pages/map.dart';
import 'package:app/pages/friends.dart';
import 'package:app/pages/profile.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeedPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          icon: const Icon(Icons.person),
        ),
        title: const Text('News Feed'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: List.generate(
                8,
                (index) => Column(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Post Header
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: CircleAvatar(
                                    radius: 14,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundImage: AssetImage(
                                          'lib/assets/Default_pfp.svg.png'),
                                    ),
                                  ),
                                ),
                                Text("Profile Name"),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {},
                                )
                              ],
                            ),
                          ),
                          //Image Display
                          Image.asset('lib/assets/square_whirl.png'),

                          //Post Footer
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25)),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.favorite_border),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.chat_bubble_outline),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.label_outline),
                                      onPressed: () {},
                                    ),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.bookmark_border),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 40, left: 15, right: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(text: "Liked by "),
                                            TextSpan(
                                              text: "Profile Name",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(text: " and"),
                                            TextSpan(
                                              text: " others",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            newRoute(context, const MapPage());
          } else if (index == 2) {
            newRoute(context, const FriendsPage());
          }
        },
      ),
    );
  }
}
