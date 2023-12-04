import 'priority.dart';
import 'status.dart';

class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.enddate,
    required this.teamsize
  });

  final String id;
  final String title;
  final String description;
  final Priority priority;
  final Status status;
  final String enddate;
  final int teamsize;
}