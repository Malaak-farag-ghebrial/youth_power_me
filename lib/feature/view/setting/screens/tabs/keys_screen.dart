import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/my_dialog.dart';
import '../../../../../core/component/my_image.dart';
import '../../../../../core/component/my_input_field.dart';
import '../../../../../core/component/my_navigator.dart';
import '../../../../../core/component/my_responsive.dart';
import '../../../../../core/component/my_text.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../controller/setting_cubit/setting_cubit.dart';
import '../../widgets/keys_card.dart';

class KeysScreen extends StatelessWidget {
  KeysScreen({super.key});

  final firstRowNumberKeyController = TextEditingController();
  final firstColumnKeyController = TextEditingController();
  final secondColumnKeyController = TextEditingController();
  final thirdColumnKeyController = TextEditingController();
  final sheetNameKeyController = TextEditingController();
  final numberKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {},
        builder: (context, state) {
      final settingCubit = SettingCubit.get(context);
      return MyResponsive(
        builder:(context,device)=> Scaffold(
          appBar: AppBar(
            title: MyText(
              AppString.keys,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                  itemCount: settingCubit.keysModel.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return KeysCard(keys: settingCubit.keysModel[index]);
                  }),
              MyAssetImageView(image: AppImages.excelInfo,fit: BoxFit.contain,height: device.screenHeight!/2,width: device.screenWidth!,),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return MyDialog(
                      title: AppString.add_keys,
                      widget: ListView(
                        shrinkWrap: true,
                        children: [
                          // todo make an information to define meaning of keys
                          MyInputField(
                            controller: sheetNameKeyController,
                            hintText: AppString.sheetName,
                            keyboardType: TextInputType.text,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: MyInputField(
                                  controller: firstRowNumberKeyController,
                                  hintText: AppString.numberOfFirstRow,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Expanded(
                                child: MyInputField(
                                  controller: numberKeyController,
                                  hintText: AppString.seriesNumber,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ],
                          ),
                          MyInputField(
                            controller: firstColumnKeyController,
                            hintText: AppString.column1,
                          ),
                          MyInputField(
                            controller: secondColumnKeyController,
                            hintText: AppString.column2,
                          ),
                          MyInputField(
                            controller: thirdColumnKeyController,
                            hintText: AppString.column3,
                          ),
                          Center(child: MyText(AppString.add_key_warning,),),
                        ],
                      ),
                      accept: () {
                        // settingCubit.addKeys(
                        //   number: numberKeyController.text.replaceAll('\n', ''),
                        //   sheetName: sheetNameKeyController.text.replaceAll('\n', ''),
                        //   name:
                        //       firstColumnKeyController.text.replaceAll('\n', ''),
                        //   phone:
                        //       secondColumnKeyController.text.replaceAll('\n', ''),
                        //   academicYear:
                        //       thirdColumnKeyController.text.replaceAll('\n', ''),
                        //   firstRowIndex:
                        //       int.parse(firstRowNumberKeyController.text),
                        //   birthDate: '',
                        // );
                        pop(context);
                      },
                    );
                  });
            },
            label: const Icon(AppIcons.add),
          ),
        ),
      );
    });
  }
}
