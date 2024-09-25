
import 'package:equatable/equatable.dart';

import '../../core/constants/api_keyword.dart';

class Attendance extends Equatable {
  final String studentCode;
  final String activityCode;
  final bool attend;
  final String date;
  final String attendTime;

  const Attendance({
    required this.studentCode,
    required this.activityCode,
    required this.attend,
    required this.date,
    required this.attendTime,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKey.studentId] = studentCode;
    data[ApiKey.activityId] = activityCode;
    data[ApiKey.attend] = attend;
    data[ApiKey.date] = date;
    data[ApiKey.attendTime] = attendTime;
    return data;
  }

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      studentCode: json[ApiKey.studentId],
      activityCode: json[ApiKey.activityId],
      attend: json[ApiKey.attend],
      date: json[ApiKey.date],
      attendTime: json[ApiKey.attendTime],
    );
  }

  @override
  List<Object?> get props => [
  ];
}
