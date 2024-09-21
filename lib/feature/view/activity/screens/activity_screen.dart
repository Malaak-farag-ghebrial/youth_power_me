import 'package:flutter/material.dart';

import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/activity_card.dart';
import '../widgets/add_activity_dialog.dart';

class ActivityScreen extends StatelessWidget {
  ActivityScreen({super.key});

  final nameController = TextEditingController();
  final pointController = TextEditingController();
  final startDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          AppString.activity,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // ActivityCubit.get(context).fieldNumber = 1;
              // await showDialog(
              //     context: context,
              //     builder: (context) {
              //       return AddActivityDialog();
              //     });
            },
            icon: const Icon(AppIcons.add),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: 2, //activityCubit.activityModel.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // return ActivityCard(
            //   activity: activityCubit.activityModel[index],
            //   onDeletePressed: () {
            //     // activityCubit.deleteActivity(index);
            //   },
            //   onEditPressed: () async {
            //     await showDialog(
            //       context: context,
            //       builder: (context) {
            //         return AddActivityDialog(
            //           activityModel: activityCubit.activityModel[index],
            //           edit: true,
            //         );
            //       },
            //     );
            //   },
            // );
          }),
    );
  }
}
