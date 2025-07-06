import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uts_project/model/safe_convert.dart';

class Name {
  final String first;
  final String last;

  const Name ({
    required this.first,
    required this.last,
  });

  factory Name.fromJson(Map<String, dynamic>? json) {
    return Name(
        first: json?['first'] ?? '',
        last: json?['last'] ?? '',
    );
  }

  toJson() => {
    'first': first,
    'last': last,
  };
}

class User {
  final String? username;
  final String? email;
  final String? picture;
  final Name? name;
  final String? gender;
  final String? phone;
  final String? location;
  final String? address;
  final String? password;
  final String? role;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  const User ({
    this.email,
    this.picture,
    this.name,
    this.gender,
    this.phone,
    this.location,
    this.address,
    this.username,
    this.password,
    this.role,
    this.id,
    this.createdAt,
    this.updatedAt
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(

        username: asString(json, 'username'),
        email: asString(json, 'email'),
        phone: asString(json, 'phone'),
        address: asString(json, 'address'),
        picture: asString(json, 'picture', defaultValue: ''), //json['picture']?['medium'],
        name: Name.fromJson(asMap(json, 'name', defaultValue: {})),
        gender: asString(json, 'gender', defaultValue: ''), //json['gender'] ?? '',
        location: asString(json, 'location', defaultValue: ''), // json['location']?['city'] ?? ''
    );
  }

  toJson() => {
    'email': email,
    'picture': picture,
    'gender': gender,
    'phone': phone,
    'location': location,
    'address': address,
    'username': username
  };

  User copyWith({
    String? email,
    String? picture,
    Name? name,
    String? gender,
    String? phone,
    String? location,
    String? address,
    String? username
  }) {
    return User(
      email: email ?? this.email,
      picture: picture ?? this.picture,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      address: address ?? this.address,
      username: username ?? this.username
    );
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