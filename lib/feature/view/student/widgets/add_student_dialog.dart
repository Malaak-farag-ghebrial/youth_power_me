import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/component/my_dialog.dart';
import '../../../../core/component/my_input_field.dart';
import '../../../../core/component/my_navigator.dart';
import '../../../../core/component/my_toast.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';

import '../../../../core/functions/date_format.dart';
import '../../../controller/student_cubit/student_cubit.dart';
import '../../../model/student.dart';

class AddStudentDialog extends StatelessWidget {
  AddStudentDialog({super.key, this.edit = false, this.student,});

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthDateController = TextEditingController();
  final academicController = TextEditingController();
  final bool edit;
  final StudentModel? student;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
        builder: (context, state) {
          if (student != null && edit) {
            nameController.text = student!.name;
            phoneController.text = student!.phone ?? '';
            academicController.text = student!.academicYear.toString();
            birthDateController.text = student!.birthDate ?? '';
          }
          return MyDialog(
            title: AppString.add_student,
            maxWidth: 450,
            maxHeight: 550,
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyInputField(
                  controller: nameController,
                  hintText: AppString.name,
                  prefixIcon: const Icon(AppIcons.person),
                ),
                MyInputField(
                  controller: phoneController,
                  hintText: AppString.phone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(AppIcons.phone),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: MyInputField(
                        controller: birthDateController,
                        hintText: AppString.birth_date,
                        prefixIcon: const Icon(AppIcons.birth_date),
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
                              birthDateController.text = dateFormat(value);
                            } else {
                              birthDateController.text = '';
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: MyInputField(
                        controller: academicController,
                        hintText: AppString.academic_year,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            accept: () {
              if (nameController.text.isNotEmpty &&
                  academicController.text.isNotEmpty) {
                if (int.tryParse(academicController.text) != null) {
                  if (edit && student != null) {
                    StudentCubit.get(context).updateStudent(
                      birthDate: birthDateController.text,
                      activityId: student!.activityIDs ?? [],
                      attendance: student!.attendance ?? [],
                      code: student!.code,
                      points: student!.points ?? [],
                      name: nameController.text,
                      phone: phoneController.text,
                      academicYear: int.parse(academicController.text),
                    );
                    pop(context);
                  } else {
                    StudentCubit.get(context).addStudent(
                      name: nameController.text,
                      phone: phoneController.text,
                      birthDate: birthDateController.text,
                      academicYear: int.parse(academicController.text),
                    );
                    pop(context);
                  }
                }
                else {
                  MyToast(msg: AppString.academic_year_is_number,
                      state: ToastStates.WARNING);
                }
              } else {
                MyToast(
                    msg: AppString.empty_field, state: ToastStates.WARNING);
              }
            },
            acceptWord: edit ? AppString.edit : AppString.add,
          );
        }
    );
  }
}
