

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'times.dart';

import '../../core/constants/api_keyword.dart';
import 'attendance.dart';

class ActivityModel extends Equatable {
  final int? id;
  final String name;
  final List<String> servantId;
  final int points;
  final List<Times> times;
  final bool available;
  final bool repeated;
  List<Attendance>? attendance;

    ActivityModel({
     this.id,
    required this.name,
     this.servantId = const[],
     this.points = 0,
    required this.times,
     this.available = true,
    required this.repeated,
     this.attendance,
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
    data[ApiKey.name] = name;
    data[ApiKey.points] = points;
    data[ApiKey.servantId] = jsonEncode(servantId.map((e)=> e).toList());
    data[ApiKey.times] = jsonEncode(times
        .map((e) => Times(
                time: e.time,
                lastTimeAttend: e.lastTimeAttend,
                day: e.day,
                date: e.date, id: e.id)
            .toJson())
        .toList());
    data[ApiKey.available] = available ? 1 : 0;
    data[ApiKey.repeated] = repeated ? 1 : 0;
    data[ApiKey.attendance] = jsonEncode(attendance?.map((e) => Attendance(
                studentId: e.studentId,
                activityId: e.activityId,
                attend: e.attend,
                date: e.date,
                attendTime: e.attendTime)
            .toJson())
        .toList());
    return data;
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json[ApiKey.id],
      name: json[ApiKey.name],
      points: json[ApiKey.points],
      servantId: List<String>.from(jsonDecode(json[ApiKey.servantId]).map((e)=> e)),
      times: List<Times>.from(jsonDecode(json[ApiKey.times]).map((e) => Times.fromJson(e))),
      available: json[ApiKey.available] == 1 ? true : false,
      repeated: json[ApiKey.repeated] == 1 ? true : false,
      attendance: List<Attendance>.from(
          jsonDecode(json[ApiKey.attendance]).map((e) => Attendance.fromJson(e))),
    );
  }

  @override
  List<Object?> get props => [
    id,
  ];

}




