import 'package:dart_mappable/dart_mappable.dart';

part 'level.mapper.dart';

@MappableClass()
class Level with LevelMappable {
  final String id;
  final String name;

  Level({required this.id, required this.name});

  static const fromMap = LevelMapper.fromMap;
  static const fromJson = LevelMapper.fromJson;
}
