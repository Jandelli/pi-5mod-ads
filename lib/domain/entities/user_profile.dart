import '../entities/user.dart'; // Add this import to access the User class

class UserProfile {
  final String id;
  final String name;
  final String email;
  String? photoUrl;
  Map<String, dynamic> additionalData;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.additionalData = const {},
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    Map<String, dynamic>? additionalData,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'additionalData': additionalData,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      additionalData: json['additionalData'] ?? {},
    );
  }

  // Fix the factory constructor to convert User to UserProfile
  factory UserProfile.fromUser(User user) {
    return UserProfile(
      id: user.id,
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
      additionalData: user.additionalData ?? {},
    );
  }
}
