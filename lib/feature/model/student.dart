import 'dart:convert';
import 'dart:math';
import 'package:equatable/equatable.dart';
import '../../core/constants/api_keyword.dart';
import 'attendance.dart';
import 'points.dart';

class StudentModel extends Equatable {
    final int id;
    final String code;
    final String? barCode;
    final String name;
    final String? phone;
     List<Points>? points;
     List<Attendance> attendance;
     List<String>? activityIDs;

  // final List<ActivityModel> activities;
  //final String gender;
    final int? academicYear;

  final String birthDate;

   StudentModel({
    required this.id,
    required this.code,
    this.barCode,
    required this.name,
    this.phone,
     this.points,
    //required this.gender,
     this.activityIDs  ,
    // required this.activities,
    this.academicYear,
     required this.attendance,
    required this.birthDate,
  });

  // StudentModel decrementIndexAtDataBase() {
  //   return StudentModel(
  //       indexAtDatabase: indexAtDatabase - 1,
  //       id: id,
  //       code: code,
  //       barCode: barCode,
  //       name: name,
  //       phone: phone,
  //       points: points,
  //       //gender: gender,
  //       activityIDs: activityIDs,
  //       // activities: activities,
  //       academicYear: academicYear,
  //       attendance: attendance,
  //     birthDate: birthDate,
  //   );
  // }
  //
  // StudentModel editSomeItems({
  //   String? editedName,
  //   String? editedPhone,
  //   String? editedBirthdate,
  //   int? editedAcademicYear,
  // }) {
  //   return StudentModel(
  //     indexAtDatabase: indexAtDatabase,
  //     id: id,
  //     code: code,
  //     barCode: barCode,
  //     name: editedName ?? name,
  //     phone: editedPhone ?? phone,
  //     points: points,
  //     activityIDs: activityIDs,
  //     academicYear: editedAcademicYear ?? academicYear,
  //     attendance: attendance,
  //     birthDate: editedBirthdate ?? birthDate,
  //   );
  // }
  //
  // StudentModel activityAdd({required List<String> editedActivityId}) {
  //   return StudentModel(
  //     indexAtDatabase: indexAtDatabase,
  //     id: id,
  //     code: code,
  //     barCode: barCode,
  //     name: name,
  //     phone: phone,
  //     points: points,
  //     activityIDs: editedActivityId,
  //     academicYear: academicYear,
  //     attendance: attendance,
  //     birthDate: birthDate,
  //   );
  // }
  //
  // StudentModel pointsAdd({required List<Points> editedPoint}) {
  //   return StudentModel(
  //       indexAtDatabase: indexAtDatabase,
  //       id: id,
  //       code: code,
  //       barCode: barCode,
  //       name: name,
  //       phone: phone,
  //       points: editedPoint,
  //       activityIDs: activityIDs,
  //       academicYear: academicYear,
  //       attendance: attendance,
  //     birthDate: birthDate,
  //   );
  // }
  //
  // StudentModel attendStudent({required List<Attendance> attend}) {
  //   return StudentModel(
  //     id: id,
  //     code: code,
  //     barCode: barCode,
  //     name: name,
  //     phone: phone,
  //     points: points,
  //     activityIDs: activityIDs,
  //     academicYear: academicYear,
  //     attendance: attend,
  //     birthDate: birthDate,
  //   );
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKey.code] = code;
    data[ApiKey.name] = name;
    data[ApiKey.points] = jsonEncode(points?.map((e) => Points(
      id: e.id,
        activityId: e.activityId,
        weekId: e.weekId,
        value: e.value,).toJson()).toList());
    data[ApiKey.phone] = phone;
    data[ApiKey.attendance] = jsonEncode(attendance.map((e) => Attendance(
          studentId: e.studentId,
          activityId: e.activityId,
          attend: e.attend,
          date: e.date,
          attendTime: e.attendTime,
        ).toJson()).toList());
    data[ApiKey.activityIds] = jsonEncode(activityIDs?.map((e) => e).toList());
    data[ApiKey.academicYear] = academicYear;
    data[ApiKey.birthDate] = birthDate;
    return data;
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json[ApiKey.id] ?? 0,
      code: json[ApiKey.code],
      barCode: json[ApiKey.barCode] ?? '',
      name: json[ApiKey.name],
      phone: json[ApiKey.phone],
      points: List<Points>.from(jsonDecode(json[ApiKey.points]).map((e)=> Points.fromJson(e))),
      activityIDs: List<String>.from(jsonDecode(json[ApiKey.activityIds]).map((e)=>e)),
      academicYear: json[ApiKey.academicYear],
      attendance: List<Attendance>.from(jsonDecode(json[ApiKey.attendance]).map((e)=>Attendance.fromJson(e))),
      birthDate: json[ApiKey.birthDate],
    );
  }

  factory StudentModel.fromExcel(
      {
      required  Map<String, dynamic> json,
     required String name,
     required String acdY,
     required String phone,
     required String num,
        required String birthDate,
      }){
    return StudentModel(
      name: json[name],
      academicYear: int.parse(json[acdY].toString()),
      id: 0,
      phone: json[phone],
      code: Random().nextInt(999999).toString(),
      points: [],
      attendance: [],
      activityIDs: [],
      birthDate: json[birthDate],
    );
  }

  @override
  List<Object?> get props => [
    id,
  ];
}
