

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../model/student.dart';

class StudentCard extends StatelessWidget {
  final StudentModel student;
  final Function()? onDeletePressed;
  final Function()? onEditPressed;
  const StudentCard({super.key, required this.student, this.onDeletePressed, this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
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
            IconButton(onPressed: onEditPressed, icon: const Icon(AppIcons.edit,color: AppColors.green,),),
            IconButton(onPressed: onDeletePressed, icon: const Icon(AppIcons.delete,color: AppColors.red,),),
          ],
        ),
      ),
    );
  }
}
