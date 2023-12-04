import 'package:tasks_management_application/models/priority.dart';
import 'package:tasks_management_application/models/status.dart';
import 'package:tasks_management_application/models/task.dart';
import 'priorities.dart';
import 'statuses.dart';

final tasks = [
  TaskItem(id: 'a', title: 'TITLE1', description: 'DESCRIPTION1', priority: priorities[Priorities.low]!, status: statuses[Statuses.todo]!, enddate: '12345', teamsize: 2),
  TaskItem(id: 'b', title: 'TITLE2', description: 'DESCRIPTION2', priority: priorities[Priorities.lowest]!, status: statuses[Statuses.inprogress]!, enddate: '23456', teamsize: 3),
  TaskItem(id: 'c', title: 'TITLE3', description: 'DESCRIPTION3', priority: priorities[Priorities.medium]!, status: statuses[Statuses.backlog]!, enddate: '87654', teamsize: 1),
  TaskItem(id: 'd', title: 'TITLE4', description: 'DESCRIPTION4', priority: priorities[Priorities.high]!, status: statuses[Statuses.done]!, enddate: '65432', teamsize: 4),
  TaskItem(id: 'e', title: 'TITLE5', description: 'DESCRIPTION5', priority: priorities[Priorities.highest]!, status: statuses[Statuses.testing]!, enddate: '98764', teamsize: 3),
];