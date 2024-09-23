import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/component/my_indicator.dart';
import '../../../../core/component/my_navigator.dart';
import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../controller/week_cubit/week_cubit.dart';
import '../widgets/add_week_dialog.dart';
import '../widgets/week_card.dart';
import 'attendance/week_activity.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeekCubit,WeekState>(
      builder: (context,state) {
        var weekCubit = WeekCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: MyText(
              AppString.week,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AddWeekDialog();
                      });
                },
                icon: const Icon(AppIcons.add),
              )
            ],
          ),
          body: state is GetWeekLoading ? const MyIndicator() : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                  itemCount: weekCubit.weekModel.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        navigateTo(context, WeekActivity(weekModel: weekCubit.weekModel[index]));
                      },
                      child: WeekCard(
                        week: weekCubit.weekModel[index],
                        onDeletePressed: (){
                        //  weekCubit.deleteWeek(index);
                        },
                      ),
                    );
                  }),
            ],
          ),
        );
      }
    );
  }
}
