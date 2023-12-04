import 'package:flutter/material.dart';

enum Priorities {
  lowest,
  low,
  medium,
  high,
  highest
}

class Priority {
  const Priority(this.title, this.color);

  final String title;
  final Color color;
}