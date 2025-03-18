import 'experience.dart';
import 'job_preference.dart';
import 'skill.dart';
import 'user.dart';

class JobSeeker extends User {
  final String bio;
  final String resumeUrl;
  final List<Experience> experiences;
  final List<Skill> skills;
  final JobPreference preferences;
  final List<String> education;
  final List<String> certifications;
  final List<String> languages;
  final List<String> likedJobs;
  final List<String> dislikedJobs;
  final List<String> matchedJobs;
  @override
  // ignore: overridden_fields
  final String photoUrl;
  final DateTime createdAt;
  final DateTime lastActive;

  const JobSeeker({
    required super.id,
    required super.name,
    required super.email,
    required this.photoUrl,
    required super.userType,
    required this.createdAt,
    required this.lastActive,
    required this.bio,
    required this.resumeUrl,
    required this.experiences,
    required this.skills,
    required this.preferences,
    required this.education,
    required this.certifications,
    required this.languages,
    required this.likedJobs,
    required this.dislikedJobs,
    required this.matchedJobs,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    photoUrl,
    createdAt,
    lastActive,
    bio,
    resumeUrl,
    experiences,
    skills,
    preferences,
    education,
    certifications,
    languages,
    likedJobs,
    dislikedJobs,
    matchedJobs,
  ];

  @override
  JobSeeker copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? userType,
    Map<String, dynamic>? additionalData,
    DateTime? createdAt,
    DateTime? lastActive,
    String? bio,
    String? resumeUrl,
    List<Experience>? experiences,
    List<Skill>? skills,
    JobPreference? preferences,
    List<String>? education,
    List<String>? certifications,
    List<String>? languages,
    List<String>? likedJobs,
    List<String>? dislikedJobs,
    List<String>? matchedJobs,
  }) {
    return JobSeeker(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      bio: bio ?? this.bio,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      experiences: experiences ?? this.experiences,
      skills: skills ?? this.skills,
      preferences: preferences ?? this.preferences,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      likedJobs: likedJobs ?? this.likedJobs,
      dislikedJobs: dislikedJobs ?? this.dislikedJobs,
      matchedJobs: matchedJobs ?? this.matchedJobs,
    );
    // Note: We're ignoring additionalData since it's not used in JobSeeker,
    // but we include it in the signature to make the override valid
  }

  factory JobSeeker.fromJson(Map<String, dynamic> json) {
    return JobSeeker(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String,
      userType: json['userType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: DateTime.parse(json['lastActive'] as String),
      bio: json['bio'] as String,
      resumeUrl: json['resumeUrl'] as String,
      experiences:
          (json['experiences'] as List)
              .map((e) => Experience.fromJson(e as Map<String, dynamic>))
              .toList(),
      skills:
          (json['skills'] as List)
              .map((e) => Skill.fromJson(e as Map<String, dynamic>))
              .toList(),
      preferences: JobPreference.fromJson(
        json['preferences'] as Map<String, dynamic>,
      ),
      education: List<String>.from(json['education'] as List),
      certifications: List<String>.from(json['certifications'] as List),
      languages: List<String>.from(json['languages'] as List),
      likedJobs: List<String>.from(json['likedJobs'] as List),
      dislikedJobs: List<String>.from(json['dislikedJobs'] as List),
      matchedJobs: List<String>.from(json['matchedJobs'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'userType': userType,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'bio': bio,
      'resumeUrl': resumeUrl,
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'preferences': preferences.toJson(),
      'education': education,
      'certifications': certifications,
      'languages': languages,
      'likedJobs': likedJobs,
      'dislikedJobs': dislikedJobs,
      'matchedJobs': matchedJobs,
    };
  }
}
