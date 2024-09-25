import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youth_power/core/component/my_toast.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../core/component/my_input_field.dart';
import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/functions/calculate_difference_to_birthdate.dart';
import '../../../../core/functions/date_format.dart';
import '../../../controller/student_cubit/student_cubit.dart';

class NearestBirthDateStudent extends StatelessWidget {
  NearestBirthDateStudent({
    super.key,
  });

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(AppString.birth_date),
      ),
      body: Column(
        children: [
          MyText(AppString.inBetween),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: MyInputField(
                  controller: startDateController,
                  hintText: AppString.start_date,
                  keyboardType: TextInputType.none,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.parse('1980-01-01'),
                      lastDate: DateTime.parse('2100-01-01'),
                      keyboardType: TextInputType.datetime,
                      initialDatePickerMode: DatePickerMode.year,
                      confirmText: AppString.ok.tr(),
                      cancelText: AppString.cancel.tr(),
                    ).then((value) {
                      if (value != null) {
                        startDateController.text = dateFormat(value);
                      }
                      if (startDateController.text.isNotEmpty &&
                          endDateController.text.isNotEmpty) {
                        StudentCubit.get(context).filterBirthDateStudent(
                            startTime: DateTime.parse(startDateController.text),
                            endTime: DateTime.parse(endDateController.text));
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: MyInputField(
                  controller: endDateController,
                  hintText: AppString.end_date,
                  keyboardType: TextInputType.none,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.parse('1980-01-01'),
                      lastDate: DateTime.parse('2100-01-01'),
                      keyboardType: TextInputType.datetime,
                      initialDatePickerMode: DatePickerMode.year,
                      confirmText: AppString.ok.tr(),
                      cancelText: AppString.cancel.tr(),
                    ).then(
                      (value) {
                        if (value != null) {
                          endDateController.text = dateFormat(value);
                        }
                        if (startDateController.text.isNotEmpty &&
                            endDateController.text.isNotEmpty) {
                          StudentCubit.get(context).filterBirthDateStudent(
                              startTime:
                                  DateTime.parse(startDateController.text),
                              endTime: DateTime.parse(endDateController.text));
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<StudentCubit, StudentState>(
                builder: (context, state) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount:
                    StudentCubit.get(context).birthDateStudentModel.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        StudentCubit.get(context)
                            .birthDateStudentModel[index]
                            .name,
                      ),
                      trailing: CircleAvatar(
                        child: IconButton(
                            onPressed: () {
                              if(StudentCubit.get(context)
                                  .birthDateStudentModel[index]
                                  .phone != null && StudentCubit.get(context)
                                  .birthDateStudentModel[index]
                                  .phone != ''){
                                StudentCubit.get(context).callPhone(
                                  StudentCubit.get(context)
                                      .birthDateStudentModel[index]
                                      .phone ??
                                      AppString.phone_not_found.tr(),
                                );
                              }else{
                                MyToast(msg: AppString.phone_not_found, state: ToastStates.WARNING);
                              }

                            },
                            icon: const Icon(AppIcons.phone)),
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (StudentCubit.get(context)
                              .birthDateStudentModel[index].phone != null &&
                              StudentCubit.get(context)
                                  .birthDateStudentModel[index].phone != '')
                              ? Text(
                            StudentCubit.get(context)
                                .birthDateStudentModel[index].phone ?? '',
                            style:
                            Theme.of(context).textTheme.labelSmall,
                          )
                              : MyText(
                            AppString.phone_not_found,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: AppColors.red),
                          ),
                          StudentCubit.get(context)
                                      .birthDateStudentModel[index]
                                      .birthDate ==
                                  null
                              ? Text(
                                  StudentCubit.get(context)
                                          .birthDateStudentModel[index]
                                          .birthDate ??
                                      AppString.birthdate_not_registered,
                                )
                              : Row(
                                  children: [
                                    Visibility(
                                      visible: StudentCubit.get(context)
                                                  .birthDateStudentModel[index]
                                                  .birthDate !=
                                              null &&
                                          difference(StudentCubit.get(context)
                                                  .birthDateStudentModel[index]
                                                  .birthDate!) ==
                                              0,
                                      child: Expanded(
                                        child: MyText(
                                          AppString.today,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: StudentCubit.get(context)
                                                  .birthDateStudentModel[index]
                                                  .birthDate !=
                                              null &&
                                          difference(StudentCubit.get(context)
                                                  .birthDateStudentModel[index]
                                                  .birthDate!) ==
                                              1,
                                      child: Expanded(
                                        child: MyText(
                                          AppString.tomorrow,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: StudentCubit.get(context)
                                                  .birthDateStudentModel[index]
                                                  .birthDate !=
                                              null &&
                                          difference(StudentCubit.get(context)
                                                  .birthDateStudentModel[index]
                                                  .birthDate!) ==
                                              -1,
                                      child: Expanded(
                                        child: MyText(
                                          AppString.yesterday,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: StudentCubit.get(context)
                                                  .birthDateStudentModel[index]
                                                  .birthDate !=
                                              null &&
                                          difference(StudentCubit.get(context)
                                                      .birthDateStudentModel[
                                                          index]
                                                      .birthDate!)
                                                  .abs() >
                                              1,
                                      child: Expanded(
                                        child: MyText(
                                          '${difference(StudentCubit.get(context).birthDateStudentModel[index].birthDate!) > 0 ? tr('left') : tr('ago')} ${difference(StudentCubit.get(context).birthDateStudentModel[index].birthDate!).abs()}  ${tr('day')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      StudentCubit.get(context)
                                              .birthDateStudentModel[index]
                                              .birthDate ??
                                          AppString.birthdate_not_registered,
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
