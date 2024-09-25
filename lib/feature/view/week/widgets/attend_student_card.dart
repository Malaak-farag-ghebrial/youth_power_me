import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
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
    var weekCubit = WeekCubit.get(context);
    var studentCubit = StudentCubit.get(context);
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

                  // Padding(
                  //     // attend
                  //     padding: const EdgeInsets.only(top: 20.0),
                  //     child: Container(
                  //       height: 40,
                  //       width: 150,
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: 5, horizontal: 5),
                  //       decoration: const BoxDecoration(
                  //           color: AppColors.primaryColor,
                  //           borderRadius: BorderRadius.all(
                  //             Radius.circular(5),
                  //           )),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           // Expanded(
                  //           //   child: Container(
                  //           //       width: 40,
                  //           //       height: 30,
                  //           //       decoration: const BoxDecoration(
                  //           //         color: AppColors.primaryColorLight,
                  //           //         borderRadius: BorderRadius.all(
                  //           //           Radius.circular(5),
                  //           //         ),
                  //           //       ),
                  //           //       child:
                  //           //           BlocBuilder<WeekCubit, WeekState>(
                  //           //               builder: (context, state) {
                  //           //         return Center(
                  //           //             child: Text(
                  //           //           weekCubit
                  //           //               .getActStudentPoint(
                  //           //                   week: weekModel.date,
                  //           //                   points: studentCubit
                  //           //                       .studentModel[
                  //           //                           studentModel
                  //           //                               .id]
                  //           //                       .points,
                  //           //                   actId: activityModel.id)
                  //           //               .toString(),
                  //           //           textAlign: TextAlign.center,
                  //           //           style: const TextStyle(
                  //           //             fontSize: 15,
                  //           //             fontWeight: FontWeight.bold,
                  //           //           ),
                  //           //         ));
                  //           //       })),
                  //           // ),
                  //           const Icon(
                  //             AppIcons.add,
                  //             color: AppColors.primaryColorLight,
                  //           ),
                  //           Expanded(
                  //             child: Container(
                  //               width: 40,
                  //               height: 30,
                  //               decoration: const BoxDecoration(
                  //                 color: AppColors.primaryColorLight,
                  //                 borderRadius: BorderRadius.all(
                  //                   Radius.circular(5),
                  //                 ),
                  //               ),
                  //               child: TextFormField(
                  //                 controller: pointsController,
                  //                 keyboardType: TextInputType.number,
                  //                 textAlign: TextAlign.center,
                  //                 decoration: const InputDecoration(
                  //                   border: InputBorder.none,
                  //                   contentPadding: EdgeInsets.only(
                  //                     bottom: 17.5,
                  //                   ),
                  //                 ),
                  //                 onFieldSubmitted: (String value) {
                  //                   // studentCubit.addPoints(
                  //                   //   studentIndex:
                  //                   //       studentModel.id,
                  //                   //   week: weekModel.date,
                  //                   //   actId: activityModel.id,
                  //                   //   points: int.parse(value),
                  //                   // );
                  //                   GlobalFunction.print(value);
                  //                   pointsController.clear();
                  //                 },
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   )
                  weekCubit.weekModel
                              .firstWhere((e) => e.id == weekModel.id)
                              .attendance
                              .firstWhereOrNull((e) =>
                                  e.activityCode == activityModel.code &&
                                  e.studentCode == studentModel.code) !=
                          null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              weekCubit.removeAttendActivityStudent(
                                  weekId: weekModel.id ?? 0,
                                  actCode: activityModel.code,
                                  stCode: studentModel.code);
                              studentCubit.removeAttendStudent(
                                  stCode: studentModel.code,
                                  actCode: activityModel.code);
                            },
                            child: Center(
                              child: Row(
                                children: [
                                  const Icon(
                                    AppIcons.check,
                                    color: AppColors.green,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    weekCubit.weekModel
                                        .firstWhere((e) => e.id == weekModel.id)
                                        .attendance
                                        .firstWhereOrNull((e) =>
                                            e.activityCode == activityModel.code &&
                                            e.studentCode == studentModel.code)!
                                        .attendTime,
                                    textDirection: ui.TextDirection.ltr,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          // not attend
                          padding: const EdgeInsets.only(top: 20.0),
                          child: InkWell(
                            onTap: () {
                              weekCubit.attendActivityStudent(
                                weekId: weekModel.id ?? 0,
                                stCode: studentModel.code,
                                actCode: activityModel.code,
                                attendTime: arabicToEnglish(DateFormat('h:mm a')
                                    .format(DateTime.now())
                                    .toString()),
                              );
                              studentCubit.attendStudent(
                                stCode: studentModel.code,
                                actCode: activityModel.code,
                                attendTime: arabicToEnglish(DateFormat('h:mm a')
                                    .format(DateTime.now())
                                    .toString()),
                              );
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
                                  style: Theme.of(context).textTheme.titleSmall,
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
  }
}
