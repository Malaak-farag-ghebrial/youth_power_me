import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/my_indicator.dart';
import '../../../../core/component/my_warning_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/functions/global_variable.dart';
import '../../../controller/activity_cubit/activity_cubit.dart';
import '../../../controller/home_cubit/home_cubit.dart';
import '../../../controller/setting_cubit/setting_cubit.dart';
import '../../../controller/student_cubit/student_cubit.dart';
import '../../../controller/week_cubit/week_cubit.dart';
import '../widgets/nav_bar_widget.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    GlobalFunction.print('token : $token');
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      var homeCubit = HomeCubit.get(context);
      var weekCubit = WeekCubit.get(context);
      var settingCubit = SettingCubit.get(context);
      var activityCubit = ActivityCubit.get(context);
      var studentCubit = StudentCubit.get(context);
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (v,d) async {
          await showDialog(
              context: context,
              builder: (context) {
                return BlocBuilder<SettingCubit, SettingState>(
                    builder: (context, settingState) {
                  return WarningDialog(
                    warning: AppString.exit_app,
                    acceptWord: AppString.ok,
                    widget: settingState is UploadBackupLoading
                        ? const MyIndicator(
                            color: AppColors.primaryColor,
                          )
                        : const SizedBox(),
                    onTap: () async {
                      if (activityCubit.activityModel.isNotEmpty &&
                          studentCubit.studentModel.isNotEmpty &&
                          weekCubit.weekModel.isNotEmpty) {
                        await SettingCubit.get(context).uploadBackup(
                          activity: activityCubit.activityModel,
                          student: studentCubit.studentModel,
                          week: weekCubit.weekModel,
                          key: settingCubit.keysModel,
                        );
                      }
                      SystemNavigator.pop();
                    },
                    cancel: (){
                      SystemNavigator.pop();
                    },
                  );
                },);
              },);
        },
        child: Scaffold(
          body: PageView.builder(
            itemCount: 4,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              homeCubit.btmNavBar(index);
            },
            itemBuilder: (context, index) {
              return homeCubit.screens[homeCubit.currentIndex];
            },
          ),
          bottomNavigationBar: const MyNavigationBar(),
        ),
      );
    });
  }
}
