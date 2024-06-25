import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'notes_model.g.dart';

// flutter packages pub run build_runner build
@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;
  @HiveField(2)
  bool isCompleted = false;
  @HiveField(3)
  DateTime creationTime;
  @HiveField(4)
  DateTime deadline;
  @HiveField(5)
  bool DeadLineSelected = false;

  NotesModel(
      {required this.title,
      required this.description,
      required this.isCompleted,
      required this.creationTime,
      required this.deadline,
      required this.DeadLineSelected});
}
