import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youth_power/core/functions/calculate_difference_to_birthdate.dart';

import '../../../core/component/my_toast.dart';
import '../../../core/constants/api_keyword.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/functions/date_format.dart';
import '../../../core/functions/global_variable.dart';
import '../../model/activity.dart';
import '../../model/attendance.dart';
import '../../model/points.dart';
import '../../model/student.dart';
import '../../model/week.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  StudentCubit() : super(StudentInitial());

  static StudentCubit get(context) => BlocProvider.of(context);

  final _fireStore = FirebaseFirestore.instance;
  List<StudentModel> studentModel = [];
  StudentModel? scannedStudent;
  List<StudentModel> searchStudentModel = [];
  List<StudentModel> absentStudentModel = [];
  List<StudentModel> birthDateStudentModel = [];

  Future<void> addStudent({
    required String name,
    String? phone,
    String? birthDate,
    required int academicYear,
    bool fromDownload = false,
  }) async {
    emit(AddStudentLoading());
    if (database != null) {
      Batch batch = database!.batch();
      try {
        batch.insert(
            ApiKey.studentTable,
            StudentModel(
                id: 0,
                code: DateTime
                    .now()
                    .millisecondsSinceEpoch
                    .toString()
                    .substring(7),
                name: name,
                points: [],
                phone: phone,
                activityIDs: [],
                attendance: [],
                academicYear: academicYear,
                birthDate: birthDate)
                .toJson());
        await batch.commit();
        emit(AddStudentSuccess());
        if (!fromDownload) {
          getStudent();
        }
      } on MyDatabaseException catch (error) {
        GlobalFunction.errorPrint(error, '');
        emit(AddPointStudentFailed());
      }
    } else {
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }
  }

  Future<void> getStudent() async {
    emit(GetStudentLoading());
    if (database != null) {
      try {
        final response = await database!.query(ApiKey.studentTable);
        studentModel = List<StudentModel>.from(
            response.map((e) => StudentModel.fromJson(e)));
        searchStudentModel = List<StudentModel>.from(
            response.map((e) => StudentModel.fromJson(e)));
        emit(GetStudentSuccess());
      } on MyDatabaseException catch (error) {
        GlobalFunction.errorPrint(error, 'get student');
        emit(GetStudentFailed());
      }
    } else {
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }
  }

  Future<void> updateStudent({
    required String code,
    required String name,
    required String? phone,
    required String? birthDate,
    required List<Attendance> attendance,
    required List<String> activityId,
    required List<Points> points,
    required int academicYear,
  }) async {
    emit(EditStudentLoading());
    if (database != null) {
      Batch batch = database!.batch();
      try {
        batch.update(
            ApiKey.studentTable,
            StudentModel(
              id: 0,
              code: code,
              name: name,
              birthDate: birthDate,
              phone: phone,
              academicYear: academicYear,
              attendance: attendance,
              activityIDs: activityId,
              points: points,
            ).toJson(),
            where: '${ApiKey.code}=?',
            whereArgs: [code]);
        await batch.commit();
        emit(EditStudentSuccess());
        getStudent();
      } on MyDatabaseException catch (error) {
        GlobalFunction.errorPrint(error, 'update student');
        emit(EditStudentFailed());
      }
    } else {
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }
  }

  Future<void> deleteStudent({required String code}) async {
    emit(DeleteStudentLoading());
    if (database != null) {
      try {
        await database!.delete(
          ApiKey.studentTable,
          where: '${ApiKey.code}=?',
          whereArgs: [code],
        );
        studentModel.removeWhere((e) => e.code == code);
        searchStudentModel.removeWhere((e) => e.code == code);
        emit(DeleteStudentSuccess());
      } on MyDatabaseException catch (error) {
        GlobalFunction.errorPrint(error, 'delete student');
        emit(DeleteStudentFailed());
      }
    } else {
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }
  }

  void searchStudent({required String searchWord}) {
    emit(SearchStudentLoading());
    searchStudentModel.clear();
    searchStudentModel.addAll(studentModel.where((e) {
      return e.name.toLowerCase().contains(searchWord.toLowerCase());
    }));
    emit(SearchStudentSuccess());
  }

  Future<void> attendStudent({
    required String stCode,
    required String actCode,
    required String attendTime,
  }) async {
    emit(AttendStudentLoading());
    try {
      StudentModel student = studentModel.firstWhere((e) => e.code == stCode);
      student.attendance.add(Attendance(
        studentCode: stCode,
        activityCode: actCode,
        attend: true,
        date: dateFormat(DateTime.now()),
        attendTime: attendTime,
      ));
      studentModel
          .firstWhere((e) => e.code == stCode)
          .attendance
          .add(Attendance(
        studentCode: stCode,
        activityCode: actCode,
        attend: true,
        date: dateFormat(DateTime.now()),
        attendTime: attendTime,
      ));
      searchStudentModel
          .firstWhere((e) => e.code == stCode)
          .attendance
          .add(Attendance(
        studentCode: stCode,
        activityCode: actCode,
        attend: true,
        date: dateFormat(DateTime.now()),
        attendTime: attendTime,
      ));
      updateStudent(
        code: student.code,
        name: student.name,
        phone: student.phone ?? '',
        birthDate: student.birthDate,
        attendance: student.attendance,
        activityId: [],
        points: [],
        academicYear: student.academicYear ?? 0,
      );
      emit(AttendStudentSuccess());
    } catch (error) {
      GlobalFunction.errorPrint(error, 'attend st');
      emit(AttendStudentFailed());
    }
  }

  void filterAbsentStudent(
      {required WeekModel week, required ActivityModel activity}) {
    emit(FilterAbsentStudentLoading());
    absentStudentModel = studentModel
        .where((s) =>
    !week.attendance.contains(week.attendance
        .firstWhereOrNull(
            (a) => a.studentCode == s.code && a.activityCode == activity.code)))
        .toList();
    emit(FilterAbsentStudentSuccess());
  }

  void filterBirthDateStudent(
      {required DateTime startTime, required DateTime endTime}) async {
    emit(FilterBirthDateStudentLoading());
    birthDateStudentModel = studentModel
        .where((s) {
      if (s.birthDate != null && s.birthDate != '') {
        return (DateTime(
            DateTime
                .now()
                .year,
            DateTime
                .parse(s.birthDate??  '2000-10-10' + '00:00:00')
                .month,
            DateTime
                .parse(s.birthDate ??  '2000-10-10' + '00:00:00')
                .day)
            .isAfter(startTime) &&
            DateTime(
                DateTime
                    .now()
                    .year,
                DateTime
                    .parse(s.birthDate ??  '2000-10-10'+ '00:00:00')
                    .month,
                DateTime
                    .parse(s.birthDate ??  '2000-10-10'+ '00:00:00')
                    .day)
                .isBefore(endTime)) ||
            DateTime(
                DateTime
                    .now()
                    .year,
                DateTime
                    .parse(s.birthDate ??  '2000-10-10'+ '00:00:00')
                    .month,
                DateTime
                    .parse(s.birthDate??  '2000-10-10'+ '00:00:00')
                    .day)
                .isAtSameMomentAs(startTime) ||
            DateTime(
                DateTime
                    .now()
                    .year,
                DateTime
                    .parse(s.birthDate ??  '2000-10-10'+ '00:00:00')
                    .month,
                DateTime
                    .parse(s.birthDate ??  '2000-10-10'+ '00:00:00')
                    .day)
                .isAtSameMomentAs(endTime);
      }else{
        return false;
      }
    })
        .toList();
    birthDateStudentModel.sort((a, b) {
      return difference(DateTime(
          DateTime
              .now()
              .year,
          DateTime
              .parse(b.birthDate ??  '2000-10-10'+ '00:00:00')
              .month,
          DateTime
              .parse(b.birthDate ??  '2000-10-10'+ '00:00:00')
              .day)
          .toString())
          .compareTo(difference(DateTime(
          DateTime
              .now()
              .year,
          DateTime
              .parse(a.birthDate ??  '2000-10-10'+ '00:00:00')
              .month,
          DateTime
              .parse(a.birthDate ??  '2000-10-10'+ '00:00:00')
              .day)
          .toString()));
    });
    emit(FilterBirthDateStudentSuccess());
  }

  Future<void> removeAttendStudent({
    required String stCode,
    required String actCode,
  }) async {
    emit(RemoveAttendStudentLoading());
    try {
      StudentModel student = studentModel.firstWhere((e) => e.code == stCode);
      student.attendance
          .removeWhere((e) =>
      e.studentCode == stCode && e.activityCode == actCode);
      studentModel
          .firstWhere((e) => e.code == stCode)
          .attendance
          .removeWhere((e) =>
      e.studentCode == stCode && e.activityCode == actCode);
      searchStudentModel
          .firstWhere((e) => e.code == stCode)
          .attendance
          .removeWhere((e) =>
      e.studentCode == stCode && e.activityCode == actCode);
      updateStudent(
        code: student.code,
        name: student.name,
        phone: student.phone ?? '',
        birthDate: student.birthDate,
        attendance: student.attendance,
        activityId: [],
        points: [],
        academicYear: student.academicYear ?? 0,
      );
      emit(RemoveAttendStudentSuccess());
    } catch (error) {
      GlobalFunction.errorPrint(error, 'remove attend st');
      emit(RemoveAttendStudentFailed());
    }
  }

  void scanStudent({required String code}) {
    emit(ScanStudentCodeLoading());
    scannedStudent = studentModel.firstWhereOrNull((element) {
      return element.code == code.trim();
    });
    emit(ScanStudentCodeSuccess());
  }

  Future<void> downloadStudent() async {
    try {
      Batch batch = database!.batch();
      final response = await _fireStore.collection(ApiKey.studentTable).get();
      List<StudentModel> st = List<StudentModel>.from(response.docs
          .map((e) => e.data()[ApiKey.student])
          .toList()[0]
          .map((e) => StudentModel.fromJson(e)));
      for (var e in st) {
        if (studentModel.firstWhereOrNull((s) =>
        s.name == e.name && s.code == e.code) == null) {
          batch.insert(
              ApiKey.studentTable,
              StudentModel(
                  id: e.id,
                  code: e.code,
                  name: e.name,
                  points: e.points,
                  phone: e.phone,
                  activityIDs: e.activityIDs,
                  attendance: e.attendance,
                  academicYear: e.academicYear,
                  birthDate: e.birthDate)
                  .toJson());
        }
      }
      await batch.commit();
      getStudent();
    } catch (error) {
      GlobalFunction.errorPrint(error, 'download student');
    }
  }

// todo excel export
//   Future<void> getStudentFromExcel({
//     required int firstRowNum,
//     required String sheetKey,
//     required String nameKey,
//     required String phoneKey,
//     required String acdYKey,
//     required String numKey,
//     required String birthDate,
// }) async {
//     emit(GetStudentFromExcelLoading());
//     try {
//       final List<StudentModel> student = await ExcelService().convertExcelToStudent(
//           firstRowNum: firstRowNum,
//           sheetKey: sheetKey,
//           nameKey: nameKey,
//           phoneKey: phoneKey,
//           acdYKey: acdYKey,
//           numKey: numKey,
//         birthDate: birthDate,
//       );
//       _putStudent(student);
//       emit(GetStudentFromExcelSuccess());
//       studentModel = List<StudentModel>.from(student);
//       searchStudentModel = List<StudentModel>.from(student);
//
//     } catch (error) {
//       GlobalFunction.errorPrint(error, 'from excel');
//     emit(GetStudentFromExcelFailed());
//     }
//   }

  void callPhone(String phone) async {
    if (await canLaunchUrl(Uri(
      scheme: 'tel',
      path: '+2$phone',
    ))) {
      await launchUrl(
          Uri(
            scheme: 'tel',
            path: '+2$phone',
          ),
          mode: LaunchMode.externalNonBrowserApplication)
          .catchError((error) {
        GlobalFunction.errorPrint(error, 'call phone');
        MyToast(msg: error.toString(), state: ToastStates.FAILED);
        return true;
      });
    }
  }
}
