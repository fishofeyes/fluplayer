import 'package:hive/hive.dart';
part 'common_event_model.g.dart';

@HiveType(typeId: 3)
class CommonEventModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int createTime;
  @HiveField(2)
  final String parameters;

  CommonEventModel({
    required this.id,
    required this.createTime,
    required this.parameters,
  });
}
