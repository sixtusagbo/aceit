import 'package:dart_mappable/dart_mappable.dart';

part 'quiz_result.mapper.dart';

@MappableClass()
class QuizResult with QuizResultMappable {
  final String id;
  @MappableField(key: 'user_id')
  final String userId;
  @MappableField(key: 'quiz_id')
  final String quizId;
  final int? score;
  final List<int?> selectedAnswers;
  final int total;
  final bool inProgress;
  final DateTime date;

  QuizResult({
    required this.id,
    required this.userId,
    required this.quizId,
    this.score,
    required this.selectedAnswers,
    required this.total,
    required this.inProgress,
    required this.date,
  });

  static const fromMap = QuizResultMapper.fromMap;
  static const fromJson = QuizResultMapper.fromJson;
}
