class User {
  final String uid;
  final String email;
  String username;
  String firstName;
  String lastName;
  List<String> friends;
  String bio;
  String? profilePicture;

  User({
    required this.uid,
    required this.email,
    this.username = '',
    this.firstName = '',
    this.lastName = '',
    this.friends = const [],
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
        "bio": bio,
        "profilePicturePath": profilePicture,
      };
}
