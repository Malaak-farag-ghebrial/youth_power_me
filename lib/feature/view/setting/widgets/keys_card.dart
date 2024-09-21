import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../controller/setting_cubit/setting_cubit.dart';
import '../../../model/keys.dart';

class KeysCard extends StatelessWidget {
  final KeysModel keys;

  const KeysCard({super.key, required this.keys});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          MyText(AppString.numberOfFirstRow,
                              data: ' : ', flip: true),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(keys.firstRowIndex.toString()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          MyText(AppString.column1, data: ' : ', flip: true),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(keys.name),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          MyText(AppString.column2, data: ' : ', flip: true),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(keys.phone),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          MyText(AppString.column3, data: ' : ', flip: true),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(keys.academicYear),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      // SettingCubit.get(context)
                      //     .deleteKeys(keys.indexAtDatabase);
                    },
                    icon: const Icon(AppIcons.delete, color: AppColors.red),
                  ),
                  IconButton(
                    onPressed: () {
                      // SettingCubit.get(context)
                      //     .activateKeys(keys.indexAtDatabase);
                    },
                    icon: keys.active
                        ? const Icon(AppIcons.check, color: AppColors.green)
                        : const Icon(AppIcons.cancel, color: AppColors.red),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },);
  }
}
