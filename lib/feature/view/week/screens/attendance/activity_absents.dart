

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/my_text.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../controller/student_cubit/student_cubit.dart';
import '../../../../model/week.dart';
import '../../widgets/absent_student_call_card.dart';

class ActivityAbsents extends StatelessWidget {
  const ActivityAbsents({super.key, required this.week});
  final WeekModel week;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit,StudentState>(
      builder: (context,state) {
        var studentCubit = StudentCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: MyText(AppString.absent),
          ),
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: studentCubit.absentStudentModel.length,
            itemBuilder: (context, index) {
              return AbsentStudentCallCard(
                student: studentCubit.absentStudentModel[index],
                week: week,
              );
            },
          ),
        );
      }
    );
  }
}
