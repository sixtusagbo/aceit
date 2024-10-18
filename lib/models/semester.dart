import 'package:dart_mappable/dart_mappable.dart';

part 'semester.mapper.dart';

@MappableClass()
class Semester with SemesterMappable {
  final String id;
  final String name;

  Semester({required this.id, required this.name});

  static const fromMap = SemesterMapper.fromMap;
  static const fromJson = SemesterMapper.fromJson;
}
