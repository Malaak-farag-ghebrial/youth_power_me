
import 'package:equatable/equatable.dart';

import '../../core/constants/api_keyword.dart';

class Attendance extends Equatable {
  final int id;
  final String studentId;
  final String activityId;
  final bool attend;
  final String date;
  final String attendTime;

  const Attendance({
    required this.id,
    required this.studentId,
    required this.activityId,
    required this.attend,
    required this.date,
    required this.attendTime,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKey.studentId] = studentId;
    data[ApiKey.activityId] = activityId;
    data[ApiKey.attend] = attend;
    data[ApiKey.date] = date;
    data[ApiKey.attendTime] = attendTime;
    return data;
  }

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json[ApiKey.id],
      studentId: json[ApiKey.studentId],
      activityId: json[ApiKey.activityId],
      attend: json[ApiKey.attend],
      date: json[ApiKey.date],
      attendTime: json[ApiKey.attendTime],
    );
  }

  @override
  List<Object?> get props => [
    id,
  ];
}
