import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/my_indicator.dart';
import '../../../../core/component/my_navigator.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../controller/setting_cubit/setting_cubit.dart';
import '../../splash/screen/test_screen.dart';
import '../widgets/menu_card.dart';
import 'tabs/keys_screen.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      return Scaffold(
        body: ListView(
          children: [
            MenuCard(
              icon: AppIcons.keys,
              cardName: AppString.keys,
              onTap: () {
                navigateTo(context, KeysScreen());
              },
            ),
            MenuCard(
              icon: AppIcons.backup,
              cardName: AppString.upload_backup,
            onTap: ()async{
              // await SettingCubit.get(context).uploadBackup(
              //     activity: ActivityCubit.get(context).activityModel,
              //     student: StudentCubit.get(context).studentModel,
              //     week: WeekCubit.get(context).weekModel,
              //     key: SettingCubit.get(context).keysModel,
              // );
            },
              restCard: state is UploadBackupLoading ? const MyIndicator() : const SizedBox(),
            ),
            MenuCard(
              icon: AppIcons.get_backup,
              cardName: AppString.download_backup,
            onTap: () async {
                // await SettingCubit.get(context).downloadBackup(
                //     downloadActivity: ActivityCubit.get(context).downloadActivity(),
                //     downloadStudent: StudentCubit.get(context).downloadStudent(),
                //     downloadWeek: WeekCubit.get(context).downloadWeek(),
                //     downloadKeys: SettingCubit.get(context).downloadKeys(),
                // );
            },
              restCard: state is DownloadBackupLoading ? const MyIndicator() : const SizedBox(),
            ),
            MenuCard(
              icon: AppIcons.excel,
              cardName: AppString.import_excel,
              onTap: () async {
              navigateTo(context, BulkUpload());
              },
            ),
          ],
        ),
      );
    });
  }
}
