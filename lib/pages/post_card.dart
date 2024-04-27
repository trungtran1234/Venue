import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                        backgroundImage:
                            //change to network image later
                            AssetImage('lib/assets/Default_pfp.svg.png'),
                      ),
                    ),
                  ),
                  Text(
                    snap['username'],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            //Image Display
            SizedBox(
              height: MediaQuery.of(context).size.height * .35,
              width: double.infinity,
              child: Image.network(
                snap['postUrl'],
                fit: BoxFit.cover,
              ),
            ),

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
                        icon: const Icon(Icons.chat_bubble_outline),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('727 likes'),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: snap['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: ' '),
                              TextSpan(
                                text: snap['description'],
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
    );
  }
}
