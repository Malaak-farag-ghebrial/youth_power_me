import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/component/my_text.dart';
import '../../../../core/component/shadow_box.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../controller/student_cubit/student_cubit.dart';
import '../../../controller/week_cubit/week_cubit.dart';
import '../../../model/student.dart';

class AttendCaller extends StatelessWidget {
  final StudentModel studentModel;

  const AttendCaller({super.key, required this.studentModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(builder: (context, state) {
      var studentCubit = StudentCubit.get(context);
      return InkWell(
        onTap: () {
          studentCubit.callPhone(studentModel.phone ?? '');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: boxShadow(),
              color: AppColors.primaryColorLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      MyText(AppString.attendance,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(' ( ${WeekCubit.get(context).weekModel.first.date} ) '),
                      const Spacer(),
                      WeekCubit.get(context).weekModel.isNotEmpty
                          ? WeekCubit.get(context)
                                      .weekModel
                                      .first
                                      .attendance
                                      .firstWhereOrNull((element) =>
                                          element.studentId ==
                                          studentModel.id) !=
                                  null
                              ? const Icon(
                                  AppIcons.check,
                                  color: AppColors.green,
                                )
                              : const Icon(
                                  AppIcons.cancel,
                                  color: AppColors.red,
                                )
                          : const SizedBox(),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(studentModel.phone ?? AppString.not_found,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      const Icon(AppIcons.arrow),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
