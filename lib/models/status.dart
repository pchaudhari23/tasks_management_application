import 'package:flutter/material.dart';

enum Statuses {
  backlog,
  todo,
  inprogress,
  testing,
  declined,
  done
}

class Status {
  const Status(this.title, this.color);

  final String title;
  final Color color;
}