
import 'package:equatable/equatable.dart';

import '../../core/constants/api_keyword.dart';

class Points extends Equatable{
  final int? id;
  final String activityId;
  final String weekId;
  final int value;

  const Points({
    this.id,
    required this.activityId,
    required this.weekId,
    this.value = 0,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKey.activityId] = activityId;
    data[ApiKey.weekId] = weekId;
    data[ApiKey.value] = value;
    return data;
  }

  factory Points.fromJson(Map<String, dynamic> json) {
    return Points(
      id: json[ApiKey.id],
      activityId: json[ApiKey.activityId],
      weekId: json[ApiKey.weekId],
      value: json[ApiKey.value],
    );
  }

  @override
  List<Object?> get props => [

  ];
}