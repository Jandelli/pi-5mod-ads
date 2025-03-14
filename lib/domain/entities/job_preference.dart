import 'package:equatable/equatable.dart';

class JobPreference extends Equatable {
  final List<String> jobTypes; // full-time, part-time, contract, etc.
  final List<String> locations; // remote, on-site, hybrid
  final double minSalary;
  final String currency;
  final List<String> industries;

  const JobPreference({
    required this.jobTypes,
    required this.locations,
    required this.minSalary,
    required this.currency,
    required this.industries,
  });

  @override
  List<Object?> get props => [
    jobTypes,
    locations,
    minSalary,
    currency,
    industries,
  ];

  factory JobPreference.fromJson(Map<String, dynamic> json) {
    return JobPreference(
      jobTypes: List<String>.from(json['jobTypes'] as List),
      locations: List<String>.from(json['locations'] as List),
      minSalary: json['minSalary'] as double,
      currency: json['currency'] as String,
      industries: List<String>.from(json['industries'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobTypes': jobTypes,
      'locations': locations,
      'minSalary': minSalary,
      'currency': currency,
      'industries': industries,
    };
  }
}
