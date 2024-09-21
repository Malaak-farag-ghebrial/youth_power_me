

import 'package:equatable/equatable.dart';

import '../../core/constants/api_keyword.dart';

class Times extends Equatable{
  final int? id;
  final String time;
  final String lastTimeAttend;
  final String day;
  final String date;

  const Times({
    this.id,
    required this.time,
    required this.lastTimeAttend,
    required this.day,
    required this.date,
  });

  // Times editTimes({
  //   String? editedTime,
  //   String? editedLastTimeAttend,
  //   String? editedDay,
  //   String? editedDate,
  // }) {
  //   return Times(
  //     time: editedTime ?? time,
  //     lastTimeAttend: editedLastTimeAttend ?? lastTimeAttend,
  //     day: editedDay ?? day,
  //     date: editedDate ?? date,
  //   );
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKey.times] = time;
    data[ApiKey.lastTimeAttend] = lastTimeAttend;
    data[ApiKey.day] = day;
    data[ApiKey.date] = date;
    return data;
  }

  factory Times.fromJson(Map<String, dynamic> json) {
    return Times(
      id: json[ApiKey.id],
      time: json[ApiKey.times],
      lastTimeAttend: json[ApiKey.lastTimeAttend],
      day: json[ApiKey.day],
      date: json[ApiKey.date],
    );
  }

  @override
  List<Object?> get props => [

  ];

}
