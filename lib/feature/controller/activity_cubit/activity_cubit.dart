import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/constants/api_keyword.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/functions/global_variable.dart';
import '../../model/activity.dart';
import '../../model/attendance.dart';
import '../../model/servant.dart';
import '../../model/times.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityInitial());

  static ActivityCubit get(context) => BlocProvider.of(context);
  final _fireStore = FirebaseFirestore.instance;
  List<ActivityModel> activityModel = [];
  bool available = true;
  bool repeated = true;
  int fieldNumber = 1;

  Future<void> addActivity({
    required String name,
    int points = 0,
    int? id,
    required bool available,
    required bool repeated,
    required List<Times> times,
    required List<Servant> servant,
    bool fromDownload = false,
  }) async {
    emit(AddActivityLoading());
    if (database != null) {
      Batch batch = database!.batch();
      try {
        batch.insert(
            ApiKey.activityTable,
            ActivityModel(
                id: id,
                code: DateTime.now()
                    .millisecondsSinceEpoch
                    .toString()
                    .substring(7),
                name: name,
                times: times,
                available: available,
                repeated: repeated,
                attendance: []).toJson());
        await batch.commit();
        emit(AddActivitySuccess());
        if(!fromDownload){
          getActivity();
        }
      } on MyDatabaseException catch (error) {
        GlobalFunction.errorPrint(error, 'add activity');
        emit(AddActivityFailed());
      }
    } else {
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }
  }

  Future<void> getActivity() async {
    emit(GetActivityLoading());
    if (database != null) {
      try {
        final response = await database!.query(ApiKey.activityTable);
        activityModel = List<ActivityModel>.from(
            response.map((e) => ActivityModel.fromJson(e)));
        GlobalFunction.print(activityModel[0].code.toString());
        GlobalFunction.print(activityModel[1].code.toString());
        emit(GetActivitySuccess());
      } on MyDatabaseException catch (error) {
        GlobalFunction.errorPrint(error, 'get activity');
        emit(GetActivityFailed());
      }
    } else {
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }
  }

  Future<void> updateActivity({
    required int id,
    required String name,
    required String code,
    int points = 0,
    required bool available,
    required bool repeated,
    required List<Times> times,
    required List<String> servants,
    List<Attendance> attendance = const [],
  }) async {
    emit(EditActivityLoading());
    if (database != null) {
      Batch batch = database!.batch();
      try {
        batch.update(
          ApiKey.activityTable,
          ActivityModel(
                  name: name,
                  times: times,
                  code: code,
                  repeated: repeated,
                  available: available,
                  servantId: servants,
                  points: points,
                  attendance: attendance)
              .toJson(),
          where: '${ApiKey.id}=?',
          whereArgs: [id],
        );
        await batch.commit();
        emit(EditActivitySuccess());
        getActivity();
      } on MyDatabaseException catch (error) {
        GlobalFunction.errorPrint(error, 'update activity');
        emit(EditActivityFailed());
      }
    } else {
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }
  }

  Future<void> deleteActivity({required int id}) async {
    emit(DeleteActivityLoading());
    if(database != null){
      try{
        await database!.delete(
          ApiKey.activityTable,
          where: '${ApiKey.id}=?',
          whereArgs: [id],
        );
        activityModel.removeWhere((e)=> e.id == id);
        emit(DeleteActivitySuccess());
      }on MyDatabaseException catch(error){
        GlobalFunction.errorPrint(error, 'delete activity');
        emit(DeleteActivityFailed());
      }
    }else{
      GlobalFunction.errorPrint('$database', 'database is null');
      emit(DatabaseFailed());
    }

  }

  Future<void> downloadActivity() async {
    try {
      Batch batch = database!.batch();
      final response = await _fireStore.collection(ApiKey.activityTable).get();
      List<ActivityModel> act = List<ActivityModel>.from(response.docs
          .map((e) => e.data()[ApiKey.activity])
          .toList()[0]
          .map((e) => ActivityModel.fromJson(e)));
      GlobalFunction.print(act.toString());
      for (var e in act) {
        if(activityModel.firstWhereOrNull((a)=> a.code == e.code) == null){
          batch.insert(
              ApiKey.activityTable,
              ActivityModel(
                  id: e.id,
                  name: e.name,
                  code: e.code,
                  times: e.times,
                  available: e.available,
                  repeated: e.repeated,
                  attendance: e.attendance).toJson());        }
      }
      await batch.commit();
      getActivity();
      GlobalFunction.print(activityModel.toString());
    } catch (error) {
      GlobalFunction.errorPrint(error, 'download activity');
    }
  }

  void addTimeField({bool add = true}) {
    if (add) {
      fieldNumber++;
    } else {
      if (fieldNumber > 1) {
        fieldNumber--;
      }
    }
    emit(AddTimeField());
  }

  void availability({required bool availability}) {
    available = availability;
    emit(EditAvailability());
  }

  void repeatability({required bool repeatability}) {
    repeated = repeatability;
    emit(EditRepeatability());
  }
}
