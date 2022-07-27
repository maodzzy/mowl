import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 0)
class ActivityModel {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  DateTime start;
  @HiveField(3)
  DateTime end;

  ActivityModel(
      {required this.name,
      required this.description,
      required this.start,
      required this.end});

  static Box<ActivityModel> dataBox = Hive.box<ActivityModel>("data");
}
