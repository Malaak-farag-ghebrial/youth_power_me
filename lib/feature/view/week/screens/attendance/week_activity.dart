import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/component/my_indicator.dart';
import '../../../../../core/component/my_navigator.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../controller/activity_cubit/activity_cubit.dart';
import '../../../../controller/student_cubit/student_cubit.dart';
import '../../../../controller/week_cubit/week_cubit.dart';
import '../../../../model/student.dart';
import '../../../../model/week.dart';
import '../../../activity/widgets/activity_card.dart';
import 'activity_attendance.dart';

class WeekActivity extends StatelessWidget {
  final WeekModel weekModel;

  const WeekActivity({super.key, required this.weekModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(builder: (context, state) {
      var weekCubit = WeekCubit.get(context);
      var activityCubit = ActivityCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(weekModel.date),
          actions: [
            IconButton(
                onPressed: () {
                  weekCubit.exportTOExcel(
                      week: weekModel,
                      activity: activityCubit.activityModel,
                      student: StudentCubit.get(context).studentModel,
                      context: context);
                },
                icon: const Icon(AppIcons.excel)),
          ],
        ),
        body: activityCubit.activityModel.isEmpty || state is GetActivityLoading
            ? const MyIndicator()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: activityCubit.activityModel.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // weekCubit.addActivityToWeek(
                      //   weekIndex: weekModel.id,
                      //   activityId: activityCubit.activityModel[index].id,
                      // );
                      StudentCubit.get(context).searchStudentModel =
                          List<StudentModel>.from(
                              StudentCubit.get(context).studentModel);
                      navigateTo(
                        context,
                        ActivityAttendance(
                          weekModel: weekModel,
                          activityModel: activityCubit.activityModel[index],
                        ),
                      );
                    },
                    child: ActivityCard(
                      activity: activityCubit.activityModel[index],
                    ),
                  );
                },
              ),
      );
    });
  }
}
