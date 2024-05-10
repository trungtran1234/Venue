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
  // File? profilePicture;
  // static const String defaultProfilePicturePath =
  //     'lib/assets/Default_pfp.svg.png';

  User(
      {required this.uid,
      required this.email,
      this.username = '',
      this.firstName = '',
      this.lastName = '',
      this.friends = 0,
      this.posts = 0,
      this.bio = "No Bio"
      //File? profilePicture
      });

  Map<String, dynamic> toJso() => {
        "uid": uid,
        "email": email,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "friends": friends,
        "posts": posts,
        "bio": bio
      };

  // ///changes username
  // void changeUsername(String newUsername) {
  //   username = newUsername;
  // }

  // ///Changes the user location
  // void changelocation(String newlocation) {
  //   location = newlocation;
  // }

  // ///Update the user bio
  // void changeBio(String newBio) {
  //   bio = newBio;
  // }

  // /// Method that increments or decrements
  // /// users friend count
  // void friendsChange() {
  //   friends++;
  // }

  // /// Method that increments or decrements
  // /// users events attended count
  // void attendedChange() {
  //   eventsAttended++;
  // }

  // /// Method that increments or decrements
  // /// users events hosted count
  // void hostedChange() {
  //   eventsHosted++;
  // }

  // void uploadProfilePicture(String filePath) {
  //   profilePicture = File(filePath);
  // }
}
