import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../core/constants/api_keyword.dart';
import 'attendance.dart';

class WeekModel extends Equatable {
  final int? id;
  final String date;
  final String day;
  final List<String> activityID;
  final List<Attendance> attendance;

  const WeekModel({
     this.id,
    required this.date,
    required this.day,
    required this.activityID,
    required this.attendance,
  });

  // WeekModel decrementIndexAtDataBase() {
  //   return WeekModel(
  //     id: id,
  //     date: date,
  //     day: day,
  //     activityID: activityID,
  //     attendance: attendance,
  //   );
  // }
  //
  // WeekModel attendanceEdit({required List<Attendance> editedAttend}) {
  //   return WeekModel(
  //     date: date,
  //     day: day,
  //     activityID: activityID,
  //     attendance: editedAttend,
  //   );
  // }
  //
  // WeekModel activityAdd({required List<String> editedActivityId}) {
  //   return WeekModel(
  //       indexAtDatabase: indexAtDatabase,
  //       date: date,
  //       day: day,
  //       activityID: editedActivityId,
  //       attendance: attendance);
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKey.day] = day;
    data[ApiKey.date] = date;
    data[ApiKey.activityIds] = jsonEncode(activityID.map((e) => e).toList());
    data[ApiKey.attendance] = jsonEncode(attendance
        .map((e) => Attendance(
              id: e.id,
              studentId: e.studentId,
              activityId: e.activityId,
              attend: e.attend,
              date: e.date,
              attendTime: e.attendTime,
            ).toJson())
        .toList());
    return data;
  }

  factory WeekModel.fromJson(Map<String, dynamic> json) {
    return WeekModel(
      id: json[ApiKey.id],
      date: json[ApiKey.date],
      day: json[ApiKey.day],
      activityID: List<String>.from(jsonDecode(json[ApiKey.activityIds]).map((e) => e)),
      attendance: List<Attendance>.from(
          jsonDecode(json[ApiKey.attendance]).map((e) => Attendance.fromJson(e))),
    );
  }

  @override
  List<Object?> get props => [id,];
}

