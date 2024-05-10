import 'dart:io';

class User {
  final String uid;
  final String email;
  String username;
  String firstName;
  String lastName;
  int friends;
  int posts;
  String bio;
  File?
      profilePicture; // Uncomment if you want to use File for profile pictures

  User({
    required this.uid,
    required this.email,
    this.username = '',
    this.firstName = '',
    this.lastName = '',
    this.friends = 0,
    this.posts = 0,
    this.bio = "No Bio",
    this.profilePicture, // Uncomment if you are using File for profile pictures
  });

  factory User.fromFirestore(Map<String, dynamic> firestoreData) {
    return User(
      uid: firestoreData['uid'],
      email: firestoreData['email'],
      username: firestoreData['username'] ?? '',
      firstName: firestoreData['firstName'] ?? '',
      lastName: firestoreData['lastName'] ?? '',
      friends: firestoreData['friends'] ?? 0,
      posts: firestoreData['posts'] ?? 0,
      bio: firestoreData['bio'] ?? "No Bio",
      // profilePicture: File(firestoreData['profilePicturePath']), // Uncomment if you store the path and want to use File
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "friends": friends,
        "posts": posts,
        "bio": bio,
        // "profilePicturePath": profilePicture?.path, // Uncomment if using File for profile pictures
      };
}
