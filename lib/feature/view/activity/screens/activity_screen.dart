import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../controller/activity_cubit/activity_cubit.dart';
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
              ActivityCubit.get(context).fieldNumber = 1;
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AddActivityDialog();
                  });
            },
            icon: const Icon(AppIcons.add),
          ),
        ],
      ),
      body: BlocBuilder<ActivityCubit,ActivityState>(
        builder: (context,state) {
          var activityCubit = ActivityCubit.get(context);
          return ListView.builder(
              itemCount: activityCubit.activityModel.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ActivityCard(
                  activity: activityCubit.activityModel[index],
                  onDeletePressed: () {
                    activityCubit.deleteActivity(id: activityCubit.activityModel[index].id ?? 0);
                  },
                  onEditPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AddActivityDialog(
                          activityModel: activityCubit.activityModel[index],
                          edit: true,
                        );
                      },
                    );
                  },
                );
              });
        }
      ),
    );
  }
}
