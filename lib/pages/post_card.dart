import 'package:app/database/firestore_methods.dart';
import 'package:app/services/like_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import './event_feed.dart';
import 'package:intl/intl.dart';

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

  Future<void> navigateToEventDetail() async {
    var eventDoc = await FirebaseFirestore.instance
                    .collection('events')
                    .doc(widget.snap['eventId'])
                    .get();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          eventDoc: eventDoc.data()!,
          eventId: widget.snap['eventId'],
        ),
      ),
    );
  }

@override
Widget build(BuildContext context) {
    String formattedDate = widget.snap['datePublished'] != null
        ? DateFormat('hh:mm a MM/dd/yyyy').format(widget.snap['datePublished'].toDate())
        : 'No date available';

    return Card(
        child: FractionallySizedBox(
            widthFactor: 1.0,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    // Post Header
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Colors.black,
                        ),
                        child: Row(
                            children: [
                                const CircleAvatar(
                                    radius: 18,
                                    child: CircleAvatar(
                                        radius: 16,
                                        backgroundImage: AssetImage('lib/assets/Default_pfp.svg.png'),
                                    ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Text(
                                        '${widget.snap['firstName']} ${widget.snap['lastName']}',
                                        style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        ' @${widget.snap['username']}',
                                        style: const TextStyle(
                                        color: Color.fromARGB(255, 203, 203, 203),
                                        ),
                                      ),
                                      ],
                                    ),

                                    const Spacer(),  // Space between last name and icon
                                    InkWell(
                                      onTap: navigateToEventDetail,
                                      child: Row(
                                      children: [
                                        Image.asset(
                                        'lib/assets/grayLogo.png',
                                        width: 32,
                                        height: 32,
                                        ),
                                        Text(
                                        '${widget.snap['event']}',
                                        style: const TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                      ],
                                      ),
                                    ),
                                    ],
                                  ),
                                ),
                            ],
                        ),
                    ),
                    // Image Display
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
                                        duration: const Duration(milliseconds: 400),
                                        onEnd: () {
                                            setState(() {
                                                isLikeAnimating = false;
                                            });
                                        },
                                        child: const Icon(Icons.favorite, color: Colors.white, size: 120),
                                    ),
                                ),
                            ],
                        ),
                    ),
                    // Post Footer
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Colors.black,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                    children: [
                                        LikeAnimation(
                                            isAnimating: widget.snap['likes'].contains(userData['username']),
                                            smallLike: true,
                                            child: IconButton(
                                                icon: widget.snap['likes'].contains(userData['username'])
                                                    ? const Icon(Icons.favorite, color: Colors.red)
                                                    : const Icon(Icons.favorite_border),
                                                onPressed: () => FirestoreMethods().likePost(
                                                    widget.snap['postId'].toString(),
                                                    userData['username'],
                                                    widget.snap['likes'],
                                                ),
                                            ),
                                        ),
                                        Text('${widget.snap['likes'].length} likes'),
                                        const Spacer(),
                                        Text(
                                              formattedDate,
                                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                                            ),
                                    ],
                                    
                                ),
                                Text(widget.snap['description']),
                            ],
                        ),
                    ),
                ],
            ),
        ),
    );
}


}