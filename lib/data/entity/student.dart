import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 1) // unique value --> typeId
class Student {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? saveDate;

  Student({required this.id, required this.name, required this.saveDate});

}