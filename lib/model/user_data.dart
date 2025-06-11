import 'dart:convert';
import 'package:http/http.dart' as http;

class Name {
  final String first;
  final String last;

  const Name ({
    required this.first,
    required this.last,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(first: json['first'], last: json['last']);
  }
}

class User {
  final String email;
  final String picture;
  final Name name;
  final String gender;
  final String phone;
  final String location;

  const User ({
    required this.email,
    required this.picture,
    required this.name,
    required this.gender,
    required this.phone,
    required this.location
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        picture: json['picture']['medium'],
        name: Name.fromJson(json['name']),
        gender: json['gender'],
        phone: json['phone'],
        location: json['location']['city']);
  }
}

class UserService {
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse("https://randomuser.me/api?results=5"),
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        final data = jsonDecode(response.body);

        // Create a list of users
        final List<User> userList = [];

        // Loop through the results and create a User object for each one
        for (var entry in data['results']) {
          userList.add(User.fromJson(entry));
        }

        // Return the list of users
        return userList;
      } else {
        // If the request was not successful, throw an exception
        throw Exception('Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // If there is a connection error, throw an exception
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }
}