import 'package:dart_mappable/dart_mappable.dart';

part 'faculty.mapper.dart';

@MappableClass()
class Faculty with FacultyMappable {
  final String id;
  final String name;
  @MappableField(key: 'school_id')
  final String schoolId;

  Faculty({required this.id, required this.name, required this.schoolId});

  static const fromMap = FacultyMapper.fromMap;
  static const fromJson = FacultyMapper.fromJson;
}
