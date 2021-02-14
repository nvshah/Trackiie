import 'package:flutter/material.dart';

class Task {
  final String name;
  final int ratePerHour;
  final String id;

  Task({
    @required this.id,
    @required this.name,
    @required this.ratePerHour,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }

  //As this constructor always not returns the Class instance i.e it may return null
  //So we're using factory Constructor instead.
  factory Task.fromMap(String id, Map<String, dynamic> map) {
    if (map == null) return null;

    return Task(
      id: id,
      name: map['name'] as String,
      ratePerHour: map['ratePerHour'] as int,
    );
  }
}
