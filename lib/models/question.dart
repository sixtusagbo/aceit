import 'package:dart_mappable/dart_mappable.dart';

part 'question.mapper.dart';

@MappableClass()
class Question with QuestionMappable {
  final String id;
  final String type;
  final String question;
  final List<String> options;
  // TODO: Add weightage to the question

  /// The index of the correct answer in the [options] list.
  final int answer;

  Question({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.answer,
  });

  static const fromMap = QuestionMapper.fromMap;
  static const fromJson = QuestionMapper.fromJson;
}
