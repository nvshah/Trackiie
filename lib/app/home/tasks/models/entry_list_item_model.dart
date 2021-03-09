import 'package:flutter/material.dart';
import 'package:time_tracker/utils/format.dart';
import 'package:time_tracker/app/home/tasks/models/entry.dart';
import 'package:time_tracker/app/home/tasks/models/task_model.dart';

class EntryListItemModel {
  final Entry entry;
  final Task task;

  EntryListItemModel({this.entry, this.task});

  String get dayOfWeek => Format.dayOfWeek(entry.start);
  String get startDate => Format.date(entry.start);
  TimeOfDay get startTime => TimeOfDay.fromDateTime(entry.start);
  TimeOfDay get endTime => TimeOfDay.fromDateTime(entry.end);
  String get durationFormatted => Format.hours(entry.durationInHours);

  double get _pay => task.ratePerHour * entry.durationInHours;
  String get payFormatted => Format.currency(_pay);
}
