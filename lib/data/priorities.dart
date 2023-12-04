import 'package:flutter/material.dart';
import 'package:tasks_management_application/models/priority.dart';

const priorities = {
  Priorities.lowest: Priority('Lowest', Color.fromARGB(255, 5, 5, 245)),
  Priorities.low: Priority('Low', Color.fromARGB(209, 37, 37, 228)),
  Priorities.medium: Priority('Medium', Color.fromARGB(255, 135, 216, 30)),
  Priorities.high: Priority('High', Color.fromARGB(255, 184, 9, 9)),
  Priorities.highest: Priority('Highest', Color.fromARGB(255, 255, 9, 9))
};