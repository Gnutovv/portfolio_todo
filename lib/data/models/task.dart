import 'package:hive_flutter/adapters.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
final class Task {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final bool isCompleted;

  factory Task.create(String title) {
    return Task(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title);
  }

  Task({required this.id, required this.title, this.isCompleted = false});

  Task copyWith({String? title, String? description, bool? isCompleted}) =>
      Task(id: id, title: title ?? this.title, isCompleted: isCompleted ?? this.isCompleted);

  Task toggleStatus() => copyWith(isCompleted: !isCompleted);

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Task && other.id == id);
  }

  @override
  int get hashCode => id.hashCode;
}
