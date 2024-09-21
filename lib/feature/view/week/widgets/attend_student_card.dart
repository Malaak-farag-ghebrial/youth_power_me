import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/functions/arabic_to_english_number.dart';
import '../../../../core/functions/global_variable.dart';
import '../../../controller/student_cubit/student_cubit.dart';
import '../../../controller/week_cubit/week_cubit.dart';
import '../../../model/activity.dart';
import '../../../model/student.dart';
import '../../../model/week.dart';

class AttendanceStudentCard extends StatelessWidget {
  final StudentModel studentModel;
  final WeekModel weekModel;
  final ActivityModel activityModel;
  final pointsController = TextEditingController();

  AttendanceStudentCard({
    super.key,
    required this.studentModel,
    required this.weekModel,
    required this.activityModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
      // buildWhen: (p, n) {
      //   if (n is AddPointStudentSuccess || n is AttendStudentSuccess ) {
      //     return true;
      //   } else {
      //     return false;
      //   }
      // },
      builder: (context, state) {
        var weekCubit = WeekCubit.get(context);
        var studentCubit = StudentCubit.get(context);
        // weekModel.attendance.forEach((e) {
        //   if (e.activityId == activityModel.id) {
        //     attend.add(e.studentId);
        //   }
        // });
        GlobalFunction.print(weekModel.attendance.firstWhereOrNull((e) =>
        e.studentId ==
            studentCubit.searchStudentModel[
            studentModel.id].id &&
            e.activityId == activityModel.id).toString(),name: 'try attend');
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      studentModel.name,
                    ),
                  ),
                  Text(studentModel.code),
                ],
              ),
              subtitle: BlocBuilder<WeekCubit, WeekState>(
                // buildWhen: (p, n) {
                //   return n is IsStudentAttendSuccess;
                // },
                builder: (context, weekState) {
                  GlobalFunction.print(studentModel.id.toString());
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            studentModel.phone ?? '',
                          ),
                        ),
                      ),
                      /*attend.contains(studentCubit.studentModel[studentModel.indexAtDatabase].id)*/
                      // weekCubit.weekModel[weekModel.indexAtDatabase]
                      //     .attendance.firstWhereOrNull((e) =>
                      // e.studentId == studentModel.id &&
                      //     e.activityId == activityModel.id) != null
                      // weekCubit.isStudentAttend(
                      //         weekIndex: weekModel.indexAtDatabase,
                      //         studentId: studentCubit
                      //             .searchStudentModel[studentModel.indexAtDatabase]
                      //             .id,
                      //         actId: activityModel.id)
                      weekModel.attendance.firstWhereOrNull((e) =>
                                  e.studentId ==
                                      studentCubit.searchStudentModel[
                                          studentModel.id].id &&
                                  e.activityId == activityModel.id) !=
                              null
                          ? Padding(
                              // attend
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                height: 40,
                                width: 150,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    )),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Expanded(
                                    //   child: Container(
                                    //       width: 40,
                                    //       height: 30,
                                    //       decoration: const BoxDecoration(
                                    //         color: AppColors.primaryColorLight,
                                    //         borderRadius: BorderRadius.all(
                                    //           Radius.circular(5),
                                    //         ),
                                    //       ),
                                    //       child:
                                    //           BlocBuilder<WeekCubit, WeekState>(
                                    //               builder: (context, state) {
                                    //         return Center(
                                    //             child: Text(
                                    //           weekCubit
                                    //               .getActStudentPoint(
                                    //                   week: weekModel.date,
                                    //                   points: studentCubit
                                    //                       .studentModel[
                                    //                           studentModel
                                    //                               .id]
                                    //                       .points,
                                    //                   actId: activityModel.id)
                                    //               .toString(),
                                    //           textAlign: TextAlign.center,
                                    //           style: const TextStyle(
                                    //             fontSize: 15,
                                    //             fontWeight: FontWeight.bold,
                                    //           ),
                                    //         ));
                                    //       })),
                                    // ),
                                    const Icon(
                                      AppIcons.add,
                                      color: AppColors.primaryColorLight,
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 40,
                                        height: 30,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryColorLight,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: pointsController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                              bottom: 17.5,
                                            ),
                                          ),
                                          onFieldSubmitted: (String value) {
                                            // studentCubit.addPoints(
                                            //   studentIndex:
                                            //       studentModel.id,
                                            //   week: weekModel.date,
                                            //   actId: activityModel.id,
                                            //   points: int.parse(value),
                                            // );
                                            GlobalFunction.print(value);
                                            pointsController.clear();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              // not attend
                              padding: const EdgeInsets.only(top: 20.0),
                              child: InkWell(
                                onTap: () {
                                  // weekCubit.attendActivityStudent(
                                  //   weekIndex: weekModel.id,
                                  //   studentId: studentModel.id,
                                  //   actId: activityModel.id,
                                  //   attendTime: arabicToEnglish(
                                  //       DateFormat('h:mm a')
                                  //           .format(DateTime.now())
                                  //           .toString()),
                                  // );
                                  // studentCubit.attendStudent(
                                  //   week: weekModel.date,
                                  //   studentIndex: studentModel.id,
                                  //   act: activityModel,
                                  //   attendTime: arabicToEnglish(
                                  //       DateFormat('h:mm a')
                                  //           .format(DateTime.now())
                                  //           .toString()),
                                  // );
                                },
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Center(
                                    child: MyText(
                                      AppString.attend,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
