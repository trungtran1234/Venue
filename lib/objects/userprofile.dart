import 'dart:io';

class UserProfile {
  String username;
  String firstName;
  String lastName;
  int friends;
  int eventsAttended;
  int eventsHosted;
  String location;
  String bio;
  File? profilePicture;
  static const String defaultProfilePicturePath =
      'lib/assets/Default_pfp.svg.png';

  UserProfile(
      {required this.username,
      required this.firstName,
      required this.lastName,
      this.friends = 0,
      this.eventsAttended = 0,
      this.eventsHosted = 0,
      required this.location,
      this.bio = "No Bio"
      //File? profilePicture

      });

  ///changes username
  void changeUsername(String newUsername) {
    username = newUsername;
  }

  ///Changes the user location
  void changelocation(String newlocation) {
    location = newlocation;
  }

  ///Update the user bio
  void changeBio(String newBio) {
    bio = newBio;
  }

  /// Method that increments or decrements
  /// users friend count
  void friendsChange() {
    friends++;
  }

  /// Method that increments or decrements
  /// users events attended count
  void attendedChange() {
    eventsAttended++;
  }

  /// Method that increments or decrements
  /// users events hosted count
  void hostedChange() {
    eventsHosted++;
  }

  void uploadProfilePicture(String filePath) {
    profilePicture = File(filePath);
  }
}
