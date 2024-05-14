import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String firstName;
  final String lastName;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String eventId;
  final String event;

  const Post({
    required this.description,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.eventId,
    required this.event,
  });

  static Post fromSnap(DocumentSnapshot snap, DocumentSnapshot user) {
    var snapshot = snap.data() as Map<String, dynamic>;
    var usersnapshot = user.data() as Map<String, dynamic>;
    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        firstName: usersnapshot["firstName"],
        lastName: usersnapshot["lastName"],
        username: usersnapshot["username"],
        postUrl: snapshot['postUrl'],
        event: snapshot['event'],
        eventId: snapshot["eventId"]);
  }



  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "event": event,
        "eventId": eventId,
      };
}
