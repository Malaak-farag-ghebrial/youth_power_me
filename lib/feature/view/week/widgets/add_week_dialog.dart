import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/component/my_dialog.dart';
import '../../../../core/component/my_input_field.dart';
import '../../../../core/component/my_navigator.dart';
import '../../../../core/component/my_toast.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/functions/date_format.dart';

class AddWeekDialog extends StatelessWidget {
  AddWeekDialog({super.key});

  final startDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MyDialog(
          title: AppString.add_week,
          widget: Column(
            children: [
              MyInputField(
                controller: startDateController,
                hintText: AppString.start_date,
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.parse('2000-01-01'),
                    lastDate: DateTime.parse('2100-01-01'),
                    keyboardType: TextInputType.datetime,
                    initialDatePickerMode: DatePickerMode.year,
                    confirmText: AppString.ok.tr(),
                    cancelText: AppString.cancel.tr(),
                  ).then((value) {
                    if (value != null) {
                      startDateController.text = dateFormat(value);
                    } else {
                      startDateController.text = '';
                    }
                  });
                },
              ),
            ],
          ),
          accept: (){
            if(startDateController.text.isNotEmpty){
             List<String> activityId = [];
             // ActivityCubit.get(context).activityModel.forEach((element) {
             //   activityId.add(element.id);
             // });
             //  weekCubit.addWeek(
             //      dateTime: DateTime.parse(startDateController.text),
             //  );
              pop(context);
            }else{
              MyToast(msg: AppString.empty_field, state: ToastStates.WARNING);
            }

          },
        );
  }
}
