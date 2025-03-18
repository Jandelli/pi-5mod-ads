import 'package:equatable/equatable.dart';

class Job extends Equatable {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String? imageUrl;
  final double salary;
  final List<String> skills;
  final String employmentType; // Full-time, Part-time, Contract, etc.

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    this.imageUrl,
    required this.salary,
    required this.skills,
    required this.employmentType,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    company,
    location,
    description,
    imageUrl,
    salary,
    skills,
    employmentType,
  ];

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'],
      title: map['title'],
      company: map['company'],
      location: map['location'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      salary: map['salary'],
      skills: List<String>.from(map['skills']),
      employmentType: map['employmentType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'salary': salary,
      'skills': skills,
      'employmentType': employmentType,
    };
  }
}
