import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> addStudent({
    required String name,
    required String phone,
    required String birthDate,
    required int academicYear,
  }) async {
    emit(AddStudentLoading());
    if (database != null) {
      Batch batch = database!.batch();
      try {
        batch.insert(
            ApiKey.studentTable,
            StudentModel(
                    id: 0,
                    code: DateTime.now()
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
        getStudent();
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
    required int id,
    required String code,
    required String name,
    required String phone,
    required String birthDate,
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
            where: '${ApiKey.id}=?',
            whereArgs: [id]);
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

  Future<void> deleteStudent({required int id}) async {
    emit(DeleteStudentLoading());
    if (database != null) {
      try {
        await database!.delete(
          ApiKey.studentTable,
          where: '${ApiKey.id}=?',
          whereArgs: [id],
        );
        studentModel.removeWhere((e) => e.id == id);
        searchStudentModel.removeWhere((e) => e.id == id);
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
// for (int i = 0; i < studentModel.length; i++) {
//   if (studentModel[i].name.toLowerCase().contains(
//       searchWord.toLowerCase())) {
//     searchStudentModel.add(studentModel[i]);
//   }
// }
    emit(SearchStudentSuccess());
  }

  Future<void> attendStudent({
    required int stId,
    required int actId,
    required String attendTime,
  }) async {
    emit(AttendStudentLoading());
    try {
      StudentModel student = studentModel.firstWhere((e) => e.id == stId);
      student.attendance.add(Attendance(
        studentId: stId,
        activityId: actId,
        attend: true,
        date: dateFormat(DateTime.now()),
        attendTime: attendTime,
      ));
      studentModel.firstWhere((e) => e.id == stId).attendance.add(Attendance(
            studentId: stId,
            activityId: actId,
            attend: true,
            date: dateFormat(DateTime.now()),
            attendTime: attendTime,
          ));
      searchStudentModel
          .firstWhere((e) => e.id == stId)
          .attendance
          .add(Attendance(
            studentId: stId,
            activityId: actId,
            attend: true,
            date: dateFormat(DateTime.now()),
            attendTime: attendTime,
          ));
      updateStudent(
        id: stId,
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

  void filterAbsentStudent({required WeekModel week,required ActivityModel activity}) {
    emit(FilterAbsentStudentLoading());
    absentStudentModel.addAll(studentModel.where(((s) =>
        week.attendance.contains(
            week.attendance.firstWhereOrNull((a) => a.studentId == s.id && a.activityId == activity.id)))).toList());
    emit(FilterAbsentStudentSuccess());
  }

  void removeFilteredAbsentStudent({
    required StudentModel student,
}){
    absentStudentModel.removeWhere((e)=> e.id == student.id);
    emit(RemoveFilteredAbsentStudentSuccess());
  }

  Future<void> removeAttendStudent({
    required int stId,
    required int actId,
  }) async {
    emit(RemoveAttendStudentLoading());
    try {
      StudentModel student = studentModel.firstWhere((e) => e.id == stId);
      student.attendance
          .removeWhere((e) => e.studentId == stId && e.activityId == actId);
      studentModel
          .firstWhere((e) => e.id == stId)
          .attendance
          .removeWhere((e) => e.studentId == stId && e.activityId == actId);
      searchStudentModel
          .firstWhere((e) => e.id == stId)
          .attendance
          .removeWhere((e) => e.studentId == stId && e.activityId == actId);
      updateStudent(
        id: stId,
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
      final response = await _fireStore.collection(ApiKey.studentTable).get();
      studentModel = List<StudentModel>.from(response.docs
          .map((e) => e.data()[ApiKey.student])
          .toList()[0]
          .map((e) => StudentModel.fromJson(e)));
      searchStudentModel = List<StudentModel>.from(response.docs
          .map((e) => e.data()[ApiKey.student])
          .toList()[0]
          .map((e) => StudentModel.fromJson(e)));
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
