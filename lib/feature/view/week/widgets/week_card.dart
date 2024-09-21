import 'package:flutter/material.dart';
import '../../../../core/component/my_chip.dart';
import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../model/week.dart';

class WeekCard extends StatelessWidget {
  final WeekModel week;
  final Function()? onDeletePressed;

  const WeekCard({super.key, required this.week, this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          week.date,
        ),
        subtitle: Row(
          children: [
            SmallChip(
              color: AppColors.primaryColor.withOpacity(0.2),
              child: MyText(
                week.day.toLowerCase(),
              ),
            ),
            // Text(activity.times[0].time),
            const Spacer(),
            IconButton(
              onPressed: onDeletePressed,
              icon: const Icon(
                AppIcons.delete,
                color: AppColors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
