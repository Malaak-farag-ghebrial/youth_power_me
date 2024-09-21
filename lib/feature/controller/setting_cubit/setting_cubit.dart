import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/component/my_toast.dart';
import '../../../core/constants/api_keyword.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/functions/global_variable.dart';
import '../../model/activity.dart';
import '../../model/keys.dart';
import '../../model/student.dart';
import '../../model/week.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial());

  static SettingCubit get(context) => BlocProvider.of(context);


  final _fireStore = FirebaseFirestore.instance;
  List<KeysModel> keysModel = [];


  Future<void> uploadBackup({
    required List<ActivityModel> activity,
    required List<StudentModel> student,
    required List<WeekModel> week,
    required List<KeysModel> key,
  }) async {
    emit(UploadBackupLoading());
    try {
      await _uploadActivity(activity: activity);
      await _uploadStudent(student: student);
      await _uploadWeek(week: week);
      await _uploadKey(key: key);
      emit(UploadBackupSuccess());
      MyToast(msg: AppString.back_upload, state: ToastStates.SUCCESS);
    } catch (error) {
      GlobalFunction.errorPrint(error, 'upload backup');
      emit(UploadBackupFailed());
    }
  }

  Future<void> _uploadActivity({required List<ActivityModel> activity}) async {
    try {
      await _fireStore
          .collection(ApiKey.activityTable)
          .doc(ApiKey.activityId)
          .set({
        ApiKey.activity: activity
            .map((e) =>
            ActivityModel(
              id: e.id,
              name: e.name,
              points: e.points,
              times: e.times,
              available: e.available,
              repeated: e.repeated,
              attendance: e.attendance,
            ).toJson())
            .toList()
      });
    } catch (error) {
      GlobalFunction.errorPrint(error, 'upload act');
    }
  }

  Future<void> _uploadStudent({required List<StudentModel> student}) async {
    try {
      await _fireStore
          .collection(ApiKey.studentTable)
          .doc(ApiKey.studentId)
          .set({
        ApiKey.student: student.map((e) {
          return StudentModel(
            id: e.id,
            code: e.code,
            name: e.name,
            phone: e.phone,
            points: e.points,
            activityIDs: e.activityIDs,
            academicYear: e.academicYear,
            attendance: e.attendance,
            birthDate: e.birthDate,
          ).toJson();
        }).toList()
      });
    } catch (error) {
      GlobalFunction.errorPrint(error, 'upload student');
    }
  }

  Future<void> _uploadWeek({required List<WeekModel> week}) async {
    try {
      await _fireStore.collection(ApiKey.weekTable).doc(ApiKey.weekTable).set({
        ApiKey.week: week.map((e) {
          return WeekModel(
            id: e.id,
            date: e.date,
            day: e.day,
            activityID: e.activityID,
            attendance: e.attendance,
          ).toJson();
        }).toList(),
      });
    } catch (error) {
      GlobalFunction.errorPrint(error, 'upload week');
    }
  }

  Future<void> _uploadKey({required List<KeysModel> key}) async {
    try {
      await _fireStore.collection(ApiKey.keysTable).doc(ApiKey.keysTable).set({
        ApiKey.keys: key
            .map(
              (e) =>
              KeysModel(
                id: e.id,
                name: e.name,
                active: e.active,
                phone: e.phone,
                academicYear: e.academicYear,
                firstRowIndex: e.firstRowIndex,
                sheetName: e.sheetName,
                numberKey: e.numberKey,
                birthDate: e.birthDate,
              ).toJson(),
        )
            .toList(),
      });
    } catch (error) {
      GlobalFunction.errorPrint(error, 'upload key');
    }
  }

  Future<void> downloadBackup({
    required Future<void> downloadActivity,
    required Future<void> downloadStudent,
    required Future<void> downloadWeek,
    required Future<void> downloadKeys,
  }) async {
    emit(DownloadBackupLoading());
    try {
      await downloadActivity;
      await downloadStudent;
      await downloadWeek;
      await downloadKeys;
      emit(DownloadBackupSuccess());
      MyToast(msg: AppString.back_download, state: ToastStates.SUCCESS);
    } catch (error) {
      GlobalFunction.errorPrint(error, 'download backup');
      emit(DownloadBackupFailed());
    }
  }

  Future<void> downloadKeys() async {
    try {
      final response = await _fireStore.collection(ApiKey.keysTable).get();
      keysModel =  List<KeysModel>.from(response.docs.map((e) => e.data()[ApiKey.keys]).toList()[0].map((e)=> KeysModel.fromJson(e)));
    }catch(error){
      GlobalFunction.errorPrint(error, 'download keys');
    }
  }


}
