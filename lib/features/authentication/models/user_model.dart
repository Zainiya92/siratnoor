import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';

class UserModel {
  final String id;
  String firstname;
  String lastname;
  final String username;
  final String email;
  String phoneNumber;
  String profilePicture;

  // New fields
  String gender;
  String religion;

  // Constructor for UserModel
  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.gender = 'Male',
    this.religion = 'Sunni',
  });

  // Helper Function to get the Fullname
  String get fullname => '$firstname $lastname';

  // Helper Function to format phone number
  String get formatePhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  // Static function to split full name into first and last name
  static List<String> nameParts(fullname) => fullname.split("");

  // Static function to generate a username from full name.
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split("");
    String firstname = nameParts[0].toLowerCase();
    String lastname = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername =
        "$firstname$lastname"; // Combine first and last name
    String usernameWithPrefix = "cwt_$camelCaseUsername"; // Add "Cwt_" Prefix
    return usernameWithPrefix;
  }

  // Static function to create an empty user model
  static UserModel empty() => UserModel(
        id: '',
        firstname: '',
        lastname: '',
        username: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
        gender: '',
        religion: '',
      );

  // Convert model to json Structure for storing data in Firebase
  Map<String, dynamic> tojson() {
    return {
      'FirstName': firstname,
      'LastName': lastname,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Gender': gender, // new
      'Religion': religion, // new
    };
  }

  // Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstname: data['FirstName'] ?? '',
        lastname: data['LastName'] ?? '',
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        gender: data['Gender'] ?? '', // new
        religion: data['Religion'] ?? '', // new
      );
    } else {
      return UserModel.empty();
    }
  }
}
