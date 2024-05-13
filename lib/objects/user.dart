import 'dart:io';

class User {
  final String uid;
  final String email;
  String username;
  String firstName;
  String lastName;
  List<String> friends; // Changed from int to List<String>
  int posts;
  String bio;
  File? profilePicture;

  User({
    required this.uid,
    required this.email,
    this.username = '',
    this.firstName = '',
    this.lastName = '',
    this.friends = const [], // Default to empty list
    this.posts = 0,
    this.bio = "No Bio",
    this.profilePicture,
  });

  factory User.fromFirestore(Map<String, dynamic> firestoreData) {
    return User(
      uid: firestoreData['uid'],
      email: firestoreData['email'],
      username: firestoreData['username'] ?? '',
      firstName: firestoreData['firstName'] ?? '',
      lastName: firestoreData['lastName'] ?? '',
      friends: List<String>.from(firestoreData['friends'] ??
          []), // Convert dynamic list to List<String>
      posts: firestoreData['posts'] ?? 0,
      bio: firestoreData['bio'] ?? "No Bio",
      profilePicture: firestoreData['profilePicturePath'] != null
          ? File(firestoreData['profilePicturePath'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "friends": friends, // Serialize list of friend UIDs
        "posts": posts,
        "bio": bio,
        "profilePicturePath": profilePicture?.path,
      };
}
