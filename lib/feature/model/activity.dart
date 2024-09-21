

import 'package:equatable/equatable.dart';
import 'times.dart';

import '../../core/constants/api_keyword.dart';
import 'attendance.dart';

class ActivityModel extends Equatable {
  final String id;
  final String name;
  final String? servant;
  final int points;
  final List<Times> times;
  final bool available;
  final bool repeated;
  final List<Attendance> attendance;

   const ActivityModel({
    required this.id,
    required this.name,
     this.servant,
     this.points = 0,
    required this.times,
     this.available = true,
    required this.repeated,
    required this.attendance,
  });

  // ActivityModel decrementIndexAtDataBase() {
  //   return ActivityModel(
  //     indexAtDatabase: indexAtDatabase - 1,
  //     id: id,
  //     name: name,
  //     points: points,
  //     times: times,
  //     available: available,
  //     repeated: repeated,
  //     attendance: attendance,
  //   );
  // }
  //
  // ActivityModel editSomeItem({
  //   String? editedName,
  //   int? editedPoints,
  //   bool? editedRepeated,
  //   bool? editedAvail,
  //   List<Times>? editedTimes,
  // }) {
  //   return ActivityModel(
  //     indexAtDatabase: indexAtDatabase,
  //     id: id,
  //     name: editedName ?? name,
  //     points: editedPoints ?? points,
  //     times: editedTimes ?? times,
  //     available: editedAvail ?? available,
  //     repeated: editedRepeated ?? repeated,
  //     attendance: attendance,
  //   );
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKey.id] = id;
    data[ApiKey.name] = name;
    data[ApiKey.points] = points;
    data[ApiKey.times] = times
        .map((e) => Times(
                time: e.time,
                lastTimeAttend: e.lastTimeAttend,
                day: e.day,
                date: e.date, id: e.id)
            .toJson())
        .toList();
    data[ApiKey.available] = available;
    data[ApiKey.repeated] = repeated;
    data[ApiKey.attendance] = attendance
        .map((e) => Attendance(
      id: e.id,
                studentId: e.studentId,
                activityId: e.activityId,
                attend: e.attend,
                date: e.date,
                attendTime: e.attendTime)
            .toJson())
        .toList();
    return data;
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json[ApiKey.id],
      name: json[ApiKey.name],
      points: json[ApiKey.points],
      times: List<Times>.from(json[ApiKey.times].map((e) => Times.fromJson(e))),
      available: json[ApiKey.available],
      repeated: json[ApiKey.repeated],
      attendance: List<Attendance>.from(
          json[ApiKey.attendance].map((e) => Attendance.fromJson(e))),
    );
  }

  @override
  List<Object?> get props => [
    id,
  ];

}




