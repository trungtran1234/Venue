import 'package:app/services/like_animation.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    //final User user = Provider.of<UserProvider>(context).getUser;

    return Card(
      child: FractionallySizedBox(
        widthFactor: 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Post Header
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
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
                    widget.snap['username'],
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
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap['postUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(Icons.favorite,
                          color: Colors.white, size: 120),
                    ),
                  ),
                ],
              ),
            ),

            //Post Footer
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      LikeAnimation(
                        isAnimating: widget.snap['likes'].contains('testUser'),
                        smallLike: true,
                        child: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {},
                        ),
                      ),
                      const Text('727'),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 40, left: 15, right: 15),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.snap['description']),
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
