import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../controller/student_cubit/student_cubit.dart';
import '../../../controller/week_cubit/week_cubit.dart';
import '../../../model/student.dart';
import '../../../model/week.dart';

class AbsentStudentCallCard extends StatelessWidget {
  const AbsentStudentCallCard(
      {super.key, required this.student, required this.week});

  final StudentModel student;
  final WeekModel week;

  @override
  Widget build(BuildContext context) {
    var weekCubit = WeekCubit.get(context);
    return InkWell(
      onTap: () {
        StudentCubit.get(context).callPhone(student.phone ?? '');
      },
      child: Card(
          child: ListTile(
            title: Text(
              student.name,
            ),
            trailing: CircleAvatar(
              child: IconButton(
                  onPressed: () {
                    StudentCubit.get(context).callPhone(student.phone ?? '');
                  },
                  icon: const Icon(AppIcons.phone)),
            ),
            subtitle: BlocBuilder<WeekCubit,WeekState>(
              builder:(context,state)=> Row(
                children: [
                  Expanded(
                    child: Text(
                      student.phone ?? '',
                    ),
                  ),
                  // Text(activity.times[0].time),
                  weekCubit.weekModel
                              .firstWhere((e) => e.id == week.id)
                              .eftkad
                              .firstWhereOrNull((e) => e == student.id) !=
                          null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              weekCubit.removeMissAbsentStudent(
                                  weekId: week.id ?? 0, studentId: student.id);
                            },
                            child:  Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MyText(AppString.eftkad),
                                  const Icon(
                                    AppIcons.check,
                                    color: AppColors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          // not eftkad
                          padding: const EdgeInsets.only(top: 20.0),
                          child: InkWell(
                            onTap: () {
                              weekCubit.missAbsentStudent(
                                  weekId: week.id ?? 0, studentId: student.id);
                            },
                            child: Container(
                              height: 30,
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration:  const BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Center(
                                child: MyText(
                                  AppString.not_eftkad,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
