import 'package:app/database/firestore_methods.dart';
import 'package:app/services/like_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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
  bool _isLoading = false;
  firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {};

  void fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
            _isLoading =
                false; // Set isLoading to false when data is successfully fetched
          });
        }
      } catch (e) {
        // Handle exceptions by setting isLoading to false and logging error or showing a message
        setState(() {
          _isLoading = false;
        });
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

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
              child: Column(
                children: [
                  Row(
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
                          '${widget.snap['firstName']} ${widget.snap['lastName']} @ ${widget.snap['event']}'),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Text(
                    '${widget.snap['username']}',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            //Image Display
            GestureDetector(
              onDoubleTap: () async {
                await FirestoreMethods().likePost(widget.snap['postId'],
                    userData['username'], widget.snap['likes']);
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
                        isAnimating:
                            widget.snap['likes'].contains(userData['username']),
                        smallLike: true,
                        child: IconButton(
                          icon: widget.snap['likes']
                                  .contains(userData['username'])
                              ? const Icon(Icons.favorite, color: Colors.red)
                              : const Icon(Icons.favorite_border),
                          onPressed: () => FirestoreMethods().likePost(
                            widget.snap['postId'].toString(),
                            userData['username'],
                            widget.snap['likes'],
                          ),
                        ),
                      ),
                      Text('${widget.snap['likes'].length}'),
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
