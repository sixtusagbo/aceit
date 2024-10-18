import 'package:dart_mappable/dart_mappable.dart';

part 'department.mapper.dart';

@MappableClass()
class Department with DepartmentMappable {
  final String id;
  final String name;
  @MappableField(key: 'faculty_id')
  final String facultyId;

  Department({required this.id, required this.name, required this.facultyId});

  static const fromMap = DepartmentMapper.fromMap;
  static const fromJson = DepartmentMapper.fromJson;
}
