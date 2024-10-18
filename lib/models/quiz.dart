import 'package:dart_mappable/dart_mappable.dart';

part 'quiz.mapper.dart';

@MappableClass()
class Quiz with QuizMappable {
  final String id;
  final String type;
  final String owner;
  @MappableField(key: 'course_id')
  final String courseId;
  final int year;

  Quiz({
    required this.id,
    required this.type,
    required this.owner,
    required this.courseId,
    required this.year,
  });

  static const fromMap = QuizMapper.fromMap;
  static const fromJson = QuizMapper.fromJson;
}
