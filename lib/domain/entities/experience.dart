import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final String id;
  final String title;
  final String company;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;
  final bool isCurrent;

  const Experience({
    required this.id,
    required this.title,
    required this.company,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.isCurrent,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    company,
    startDate,
    endDate,
    description,
    isCurrent,
  ];

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate:
          json['endDate'] != null
              ? DateTime.parse(json['endDate'] as String)
              : null,
      description: json['description'] as String,
      isCurrent: json['isCurrent'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
      'isCurrent': isCurrent,
    };
  }
}
