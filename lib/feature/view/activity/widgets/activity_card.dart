
import 'package:flutter/material.dart';

import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../model/activity.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final Function()? onDeletePressed;
  final Function()? onEditPressed;
  const ActivityCard({super.key, required this.activity,this.onDeletePressed, this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(activity.name,),
        trailing: CircleAvatar(
          child: Text(activity.points.toString()),
        ),
        subtitle: Row(
          children: [
            // Expanded(child: Text(activity.times[0].day,),),
            // Text(activity.times[0].time),
            Expanded(
              child: SizedBox(
                height: 20,
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: activity.times.length,
                    itemBuilder: (context,index){
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyText(activity.times[index].day.toLowerCase(),),
                      index != activity.times.length -1 ? const Text(' - ') : const SizedBox(),
                    ],
                  );
                }),
              ),
            ),
            Visibility(
                visible: onDeletePressed != null,
                child: IconButton(onPressed: onDeletePressed, icon: const Icon(AppIcons.delete,color: AppColors.red,),)),
            Visibility(
                visible: onEditPressed != null,
                child: IconButton(onPressed: onEditPressed, icon: const Icon(AppIcons.edit,color: AppColors.green,),)),
          ],
        ),
      ),
    );
  }
}
