import 'package:dart_mappable/dart_mappable.dart';

part 'course.mapper.dart';

@MappableClass()
class Course with CourseMappable {
  final String id;
  final String code;
  final String title;
  @MappableField(key: 'department_id')
  final String departmentId;
  @MappableField(key: 'level_id')
  final String levelId;
  @MappableField(key: 'semester_id')
  final String? semesterId;

  Course({
    required this.id,
    required this.code,
    required this.title,
    required this.departmentId,
    required this.levelId,
    this.semesterId,
  });

  static const fromMap = CourseMapper.fromMap;
  static const fromJson = CourseMapper.fromJson;
}
