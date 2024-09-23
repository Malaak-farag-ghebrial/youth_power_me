import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:youth_power/core/constants/api_keyword.dart';

import 'attendance.dart';

class Servant extends Equatable {
  final int id;
  final String name;
  final String code;
  final String phone;
  final List<Attendance> attendance;
  final List<String> activityIDs;

  const Servant(
      {required this.id,
      required this.name,
      required this.code,
      required this.phone,
      required this.attendance,
      required this.activityIDs});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ApiKey.id] = id;
    data[ApiKey.name] = name;
    data[ApiKey.code] = code;
    data[ApiKey.phone] = phone;
    data[ApiKey.attendance] = attendance
        .map((e) => Attendance(
            studentId: e.studentId,
            activityId: e.activityId,
            attend: e.attend,
            date: e.date,
            attendTime: e.attendTime))
        .toList();
    data[ApiKey.activity] = activityIDs.map((e) => e);
    return data;
  }

  @override
  List<Object?> get props => [id];
}
