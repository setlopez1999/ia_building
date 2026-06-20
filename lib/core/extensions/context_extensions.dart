import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void push(String route) => Navigator.of(this).pushNamed(route);
  void pop() => Navigator.of(this).pop();
}
