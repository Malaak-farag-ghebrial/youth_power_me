import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/api_keyword.dart';
import '../../../core/functions/global_variable.dart';
import '../../model/activity.dart';
import '../../model/attendance.dart';
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

})async{

}







  Future<void> downloadActivity() async {
    try {
      final response = await _fireStore.collection(ApiKey.activityTable).get();
      activityModel = List<ActivityModel>.from(response.docs
          .map((e) => e.data()[ApiKey.activity])
          .toList()[0]
          .map((e) => ActivityModel.fromJson(e)));
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
