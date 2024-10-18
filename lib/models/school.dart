import 'package:dart_mappable/dart_mappable.dart';

part 'school.mapper.dart';

@MappableClass()
class School with SchoolMappable {
  final String id;
  final String name;

  School({required this.id, required this.name});

  static const fromMap = SchoolMapper.fromMap;
  static const fromJson = SchoolMapper.fromJson;
}
