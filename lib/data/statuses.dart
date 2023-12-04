import 'package:flutter/material.dart';
import 'package:tasks_management_application/models/status.dart';
 
const statuses = {
  Statuses.backlog: Status('Backlog', Color.fromRGBO(231, 214, 214, 1)),
  Statuses.todo: Status('To Do', Color.fromRGBO(32, 9, 165, 1)),
  Statuses.inprogress: Status('In Progress', Color.fromRGBO(5, 9, 207, 1)),
  Statuses.testing: Status('Testing', Color.fromRGBO(176, 212, 13, 1)),
  Statuses.declined: Status('Declined', Color.fromRGBO(236, 137, 7, 1)),
  Statuses.done: Status('Done', Color.fromRGBO(115, 231, 7, 1)),
};