
import 'package:flutter/material.dart';
import 'package:youth_power/feature/controller/student_cubit/student_cubit.dart';
import 'package:youth_power/feature/model/student.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';

class AbsentStudentCallCard extends StatelessWidget {
  const AbsentStudentCallCard({super.key, required this.student});
  final StudentModel student;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        StudentCubit.get(context).callPhone(student.phone ?? '');
      },
      child: Card(
        child: ListTile(
          title: Text(student.name,),
          trailing: CircleAvatar(
            child: Text(student.id.toString()),
          ),
          subtitle: Row(
            children: [
              Expanded(child: Text(student.phone ?? '',),),
              // Text(activity.times[0].time),
              const Spacer(),
              IconButton(onPressed: (){
                StudentCubit.get(context).removeFilteredAbsentStudent(student: student);
              }, icon: const Icon(AppIcons.remove,color: AppColors.red,),),
            ],
          ),
        ),
      ),
    );
  }
}
