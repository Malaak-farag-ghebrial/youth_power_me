import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/component/my_toast.dart';
import '../../../core/constants/api_keyword.dart';
import '../../../core/functions/global_variable.dart';
import '../../model/student.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  StudentCubit() : super(StudentInitial());

  static StudentCubit get(context) => BlocProvider.of(context);

  final _fireStore = FirebaseFirestore.instance;
  List<StudentModel> studentModel = [];
  StudentModel? scannedStudent;
  List<StudentModel> searchStudentModel = [];



  void searchStudent({required String searchWord}) {
    emit(SearchStudentLoading());
    searchStudentModel.clear();
    searchStudentModel.addAll(studentModel.where((e){
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

  void scanStudent({
    required String code
  }) {
    emit(ScanStudentCodeLoading());
    scannedStudent = studentModel
        .firstWhereOrNull((element) {
      return element.code == code.trim();
    });
    emit(ScanStudentCodeSuccess());
  }

  Future<void> downloadStudent() async {
    try {
      final response = await _fireStore.collection(ApiKey.studentTable).get();
      studentModel = List<StudentModel>.from(
          response.docs.map((e) => e.data()[ApiKey.student]).toList()[0].map((
              e) => StudentModel.fromJson(e)));
      searchStudentModel = List<StudentModel>.from(
          response.docs.map((e) => e.data()[ApiKey.student]).toList()[0].map((
              e) => StudentModel.fromJson(e)));
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
