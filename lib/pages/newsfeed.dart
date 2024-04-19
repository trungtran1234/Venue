import 'package:flutter/material.dart';
import 'package:app/functions.dart';
import 'package:flutter/widgets.dart';

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
        leading: profile(context),
      ),
      body: newsFeed(),
      bottomNavigationBar: buildBottomNavigationBar(context, _selectedIndex),
    );
  }

  SingleChildScrollView newsFeed() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: List.generate(
              8,
              (index) => Column(
                children: [
                  Card(
                    child: FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Post Header
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const CircleAvatar(
                                    radius: 14,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundImage: AssetImage(
                                          'lib/assets/Default_pfp.svg.png'),
                                    ),
                                  ),
                                ),
                                const Text("Profile Name"),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {},
                                )
                              ],
                            ),
                          ),
                          //Image Display
                          Image.asset('lib/assets/square_whirl.png'),

                          //Post Footer
                          Container(
                            decoration: const BoxDecoration(
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
                                      icon: const Icon(Icons.favorite_border),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon:
                                          const Icon(Icons.chat_bubble_outline),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.label_outline),
                                      onPressed: () {},
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.bookmark_border),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 40, left: 15, right: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: const TextSpan(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
