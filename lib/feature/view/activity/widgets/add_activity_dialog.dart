import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/my_dialog.dart';
import '../../../../core/component/my_input_field.dart';
import '../../../../core/component/my_navigator.dart';
import '../../../../core/component/my_text.dart';
import '../../../../core/component/my_toast.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/functions/arabic_to_english_number.dart';
import '../../../../core/functions/date_format.dart';
import '../../../../core/functions/global_variable.dart';
import '../../../controller/activity_cubit/activity_cubit.dart';
import '../../../model/activity.dart';
import '../../../model/times.dart';

class AddActivityDialog extends StatelessWidget {
  final ActivityModel? activityModel;
  final bool edit;
  final nameController = TextEditingController();
  final pointController = TextEditingController();
  final List<TextEditingController> startDateController = [
    TextEditingController(),
  ];
  final List<TextEditingController> timeController = [
    TextEditingController(),
  ];
  final List<TextEditingController> lastTimeController = [
    TextEditingController(),
  ];
  final List<Times> times = [
    const Times(time: '', lastTimeAttend: '', day: '', date: '', id: 0)
  ];

  AddActivityDialog({super.key, this.activityModel, this.edit = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(builder: (context, state) {
      var activityCubit = ActivityCubit.get(context);
      if (edit && activityModel != null) {
        nameController.text = activityModel!.name;
        pointController.text = activityModel!.points.toString();
        startDateController.addAll(List.generate(
            activityModel!.times.length - 1,
            (index) => TextEditingController()));
        timeController.addAll(List.generate(activityModel!.times.length - 1,
            (index) => TextEditingController()));
        lastTimeController.addAll(List.generate(activityModel!.times.length - 1,
            (index) => TextEditingController()));
        times.addAll(List.generate(activityModel!.times.length - 1,
            (index) => const Times(time: '', lastTimeAttend: '', day: '', date: '')));
        for (int i = 0; i < activityModel!.times.length; i++) {
          startDateController[i].text = activityModel!.times[i].date;
          timeController[i].text = activityModel!.times[i].time;
          lastTimeController[i].text = activityModel!.times[i].lastTimeAttend;
          times[i] = activityModel!.times[i];
        }
      }
      return MyDialog(
        title: AppString.add_activity,
        maxWidth: 450,
        maxHeight: 550,
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyInputField(
              controller: nameController,
              hintText: AppString.name,
            ),
            MyInputField(
              controller: pointController,
              keyboardType: TextInputType.number,
              hintText: AppString.points,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          MyText(
                            AppString.available,
                          ),
                          const Spacer(),
                          Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: activityCubit.available,
                              // title: MyText(AppString.available,),
                              onChanged: (value) {
                                activityCubit.availability(availability: value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          MyText(
                            AppString.repeated,
                          ),
                          const Spacer(),
                          Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: activityCubit.repeated,
                              // title: MyText(AppString.repeated,),
                              onChanged: (value) {
                                activityCubit.repeatability(
                                    repeatability: value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                minHeight: 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                      itemCount: edit
                          ? state is AddTimeField
                              ? ActivityCubit.get(context).fieldNumber
                              : activityModel!.times.length
                          : ActivityCubit.get(context).fieldNumber,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: MyInputField(
                                controller: startDateController[index],
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
                                      startDateController[index].text =
                                          dateFormat(value);
                                      times[index] = Times(
                                        time: timeController[index].text,
                                        lastTimeAttend:
                                            lastTimeController[index].text,
                                        day: DateFormat('EEEE')
                                            .format(value)
                                            .toString(),
                                        date: dateFormat(value),
                                      );
                                      GlobalFunction.print(times.toString());
                                    } else {
                                      startDateController[index].text = '';
                                    }
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: MyInputField(
                                controller: timeController[index],
                                hintText: AppString.time,
                                onTap: () async {
                                  await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    confirmText: AppString.ok.tr(),
                                    cancelText: AppString.cancel.tr(),
                                  ).then((value) {
                                    if (value != null) {
                                      timeController[index].text =
                                          value.format(context).toString();
                                      times[index] = Times(
                                          time:
                                              value.format(context).toString(),
                                          lastTimeAttend:
                                              lastTimeController[index].text,
                                          day: DateFormat('EEEE').format(
                                              DateTime.parse(
                                                  startDateController[index]
                                                      .text)),
                                          date:
                                              startDateController[index].text);
                                      GlobalFunction.print(
                                          value.format(context).toString());
                                      GlobalFunction.print(times.toString());
                                      GlobalFunction.print(
                                          value.format(context).toString());
                                    } else {
                                      timeController[index].text = '';
                                    }
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: MyInputField(
                                controller: lastTimeController[index],
                                hintText: AppString.last_time,
                                onTap: () async {
                                  await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    confirmText: AppString.ok.tr(),
                                    cancelText: AppString.cancel.tr(),
                                  ).then((value) {
                                    if (value != null) {
                                      lastTimeController[index].text =
                                          value.format(context).toString();
                                      times[index] = Times(
                                          time: timeController[index].text,
                                          lastTimeAttend:
                                              value.format(context).toString(),
                                          day: DateFormat('EEEE').format(
                                              DateTime.parse(
                                                  startDateController[index]
                                                      .text)),
                                          date:
                                              startDateController[index].text);
                                      GlobalFunction.print(
                                          value.format(context).toString());
                                      GlobalFunction.print(times.toString());
                                    } else {
                                      lastTimeController[index].text = '';
                                    }
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: index != 0,
                              child: IconButton(
                                onPressed: () {
                                  ActivityCubit.get(context)
                                      .addTimeField(add: false);
                                  if (ActivityCubit.get(context).fieldNumber >
                                      1) {
                                    timeController.removeAt(index);
                                    lastTimeController.removeAt(index);
                                    startDateController.removeAt(index);
                                    times.removeAt(index);
                                  }
                                },
                                icon: const Icon(AppIcons.minus_circle),
                              ),
                            ),
                          ],
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: InkWell(
                      onTap: () {
                        timeController.add(TextEditingController());
                        lastTimeController.add(TextEditingController());
                        startDateController.add(TextEditingController());
                        times.add(const Times(
                            time: '', lastTimeAttend: '', day: '', date: ''));
                        ActivityCubit.get(context).addTimeField();
                      },
                      child: const Row(
                        children: [
                          Icon(
                            AppIcons.add_circle,
                          ),
                          SizedBox(width: 20),
                          MyText(
                            AppString.add_time,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // TypeAheadField<Servant>(
            //   itemBuilder: (context, servant) {
            //     return Text(servant.name);
            //   },
            //   onSelected: (servant) {},
            //   suggestionsCallback: (pattern) {
            //
            //   },
            // ),
          ],
        ),
        accept: () {
          if (nameController.text.isNotEmpty && times.isNotEmpty) {
            if (edit) {
              activityCubit.updateActivity(
                name: nameController.text,
                available: activityCubit.available,
                repeated: activityCubit.repeated,
                points: int.tryParse(pointController.text) ?? 0,
                servants: [],
                times: List.from(
                  times.map(
                    (e) => Times(
                      time: arabicToEnglish(e.time),
                      lastTimeAttend: arabicToEnglish(e.lastTimeAttend),
                      day: e.day,
                      date: arabicToEnglish(e.date),
                    ),
                  ),
                ),
                id: activityModel!.id ?? 0,
              );
            } else {
              ActivityCubit.get(context).addActivity(
                name: nameController.text,
                points: int.tryParse(pointController.text) ?? 0,
                times: List.from(
                  times.map(
                    (e) => Times(
                      time: arabicToEnglish(e.time),
                      lastTimeAttend: arabicToEnglish(e.lastTimeAttend),
                      day: e.day,
                      date: arabicToEnglish(e.date),
                    ),
                  ),
                ),
                servant: [],
                available: activityCubit.available,
                repeated: activityCubit.repeated,
              );
            }
            pop(context);
          } else {
            MyToast(msg: AppString.empty_field, state: ToastStates.WARNING);
          }
        },
      );
    });
  }
}
