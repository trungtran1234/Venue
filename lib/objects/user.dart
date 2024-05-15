class User {
  final String uid;
  final String email;
  String username;
  String firstName;
  String lastName;
  List<String> friends;
  int posts;
  String bio;
  String? profilePicture;

  User({
    required this.uid,
    required this.email,
    this.username = '',
    this.firstName = '',
    this.lastName = '',
    this.friends = const [],
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
      friends: List<String>.from(firestoreData['friends'] ?? []),
      posts: firestoreData['posts'] ?? 0,
      bio: firestoreData['bio'] ?? "No Bio",
      profilePicture: firestoreData['profilePicturePath'],
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
        "profilePicturePath": profilePicture,
      };
}
