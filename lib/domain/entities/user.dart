import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String userType;
  final String? photoUrl;
  final Map<String, dynamic>? additionalData;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.userType = '',
    this.photoUrl,
    this.additionalData,
  });

  // Add getters for accessing the properties
  String get getId => id;
  String get getEmail => email;
  String get getName => name;
  String get getUserType => userType;
  String? get getPhotoUrl => photoUrl;
  Map<String, dynamic>? get getAdditionalData => additionalData;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      userType: json['userType'] ?? '',
      photoUrl: json['photoUrl'],
      additionalData: json['additionalData'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    userType,
    photoUrl,
    additionalData,
  ];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? userType,
    String? photoUrl,
    Map<String, dynamic>? additionalData,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      userType: userType ?? this.userType,
      photoUrl: photoUrl ?? this.photoUrl,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
