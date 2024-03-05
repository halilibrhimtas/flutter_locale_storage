import 'dart:convert';

class Person {
  final int? id;
  final String? name;
  final String? saveDate;

  Person({required this.id, required this.name, required this.saveDate});

  factory Person.fromJson(Map<String, dynamic> json) =>
      Person(id: json['id'], name: json['name'], saveDate: json['saveDate']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'saveDate': saveDate,
      };
}
