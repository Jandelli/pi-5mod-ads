import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  final String id;
  final String name;
  final int level; // 1-5 indicating proficiency

  const Skill({required this.id, required this.name, required this.level});

  @override
  List<Object?> get props => [id, name, level];

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'level': level};
  }
}
