import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youth_power/core/component/my_toast.dart';
import 'package:youth_power/core/functions/calculate_difference_to_birthdate.dart';
import '../../../../core/component/shadow_box.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/component/my_chip.dart';
import '../../../../core/component/my_dialog.dart';
import '../../../../core/component/my_navigator.dart';
import '../../../../core/component/my_responsive.dart';
import '../../../../core/component/my_text.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/functions/global_variable.dart';
import '../../../controller/activity_cubit/activity_cubit.dart';
import '../../../controller/student_cubit/student_cubit.dart';
import '../../../model/activity.dart';
import '../../../model/student.dart';
import '../../setting/widgets/menu_card.dart';
import '../widgets/add_student_dialog.dart';
import '../widgets/call_attend_widget.dart';
import '../widgets/qr_code_widget.dart';

class StudentDetail extends StatelessWidget {
  final StudentModel studentModel;

  const StudentDetail({super.key, required this.studentModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(builder: (context, state) {
      var studentCubit = StudentCubit.get(context);
      List<ActivityModel> activity = [];
      List<ActivityModel> act = [];
      for (var item in studentModel.activityIDs ?? []) {
        ActivityCubit.get(context).activityModel.firstWhereOrNull((element) {
          if (element.id == item) {
            activity.add(element);
          }
          return element.id == item;
        });
      }
      for (var i in studentModel.points ?? []) {
        ActivityCubit.get(context).activityModel.firstWhereOrNull((element) {
          if (element.id == i.activityId) {
            act.add(element);
          }
          return element.id == i.activityId;
        });
      }
      return Scaffold(
        body: MyResponsive(builder: (context, device) {
          switch (device.deviceType) {
            case DeviceType.mobile:
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Visibility(
                        visible: !kIsWeb,
                        child: SizedBox(
                          height: 30,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: CircleAvatar(
                          maxRadius: 40,
                          minRadius: 10,
                          child: Center(
                            child: Text(
                              studentModel.academicYear.toString(),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        studentModel.code,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        studentModel.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          if(studentModel.phone !=  null && studentModel.phone != ''){
                            studentCubit.callPhone(studentModel.phone ?? '');
                          }else{
                            MyToast(msg: AppString.phone_not_found, state: ToastStates.WARNING);
                          }

                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (studentModel.phone != null &&
                                    studentModel.phone != '')
                                ? Text(
                                    studentModel.phone ?? '',
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
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              AppIcons.phone,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  StudentCubit.get(context)
                                      .deleteStudent(code: studentModel.code);
                                  pop(context);
                                },
                                child: SmallChip(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.2),
                                  child: const Icon(
                                    AppIcons.delete,
                                    color: AppColors.red,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AddStudentDialog(
                                        edit: true,
                                        student: studentCubit.studentModel
                                            .firstWhere(
                                                (e) => e.id == studentModel.id),
                                      );
                                    },
                                  );
                                  pop(context);
                                },
                                child: SmallChip(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.2),
                                  child: const Icon(
                                    AppIcons.edit,
                                    color: AppColors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MenuCard(
                        icon: AppIcons.points,
                        cardName: AppString.points,
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return MyDialog(
                                title: AppString.points,
                                widget: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const MyText(AppString.under_development),
                                    ListView.builder(
                                      itemBuilder: (context, index) {
                                        return MenuCard(
                                          icon: AppIcons.circle,
                                          cardName: act[index].name,
                                          restCard: Text(
                                            studentModel.points![index].value
                                                .toString(),
                                          ),
                                        );
                                      },
                                      shrinkWrap: true,
                                      itemCount: studentModel.points!.length,
                                    ),
                                    const Row(
                                      children: [
                                        Expanded(
                                          child: MyText(
                                            AppString.total,
                                          ),
                                        ),
                                        // Text(studentCubit
                                        //     .studentPoints(studentModel.points)
                                        //     .toString()),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // MenuCard(
                      //   icon: AppIcons.activity,
                      //   cardName: AppString.activity,
                      //   onTap: () async {
                      //     await showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return MyDialog(
                      //           title: AppString.activity,
                      //           widget: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               ListView.builder(
                      //                 itemBuilder: (context, index) {
                      //                   return MenuCard(
                      //                     icon: AppIcons.circle,
                      //                     cardName: activity[index].name,
                      //                     restCard: const SizedBox(),
                      //                   );
                      //                 },
                      //                 shrinkWrap: true,
                      //                 itemCount: activity.length,
                      //               ),
                      //             ],
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: boxShadow(),
                            color: AppColors.primaryColorLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: [
                                  const Icon(
                                    AppIcons.birth_date,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: MyText(AppString.birth_date,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ),
                                  studentModel.birthDate != null &&
                                          studentModel.birthDate != ''
                                      ? Text(studentModel.birthDate ??
                                          AppString.birthdate_not_registered)
                                      : MyText(
                                          AppString.birthdate_not_registered,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(color: AppColors.red),
                                        ),
                                ],
                              ),
                              subtitle: studentModel.birthDate != null &&
                                      studentModel.birthDate != ''
                                  ? Row(
                                      children: [
                                        Visibility(
                                          visible: studentModel.birthDate !=
                                                  null &&
                                              difference(
                                                      studentModel.birthDate ??
                                                          '2000-10-10') ==
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
                                          visible: studentModel.birthDate !=
                                                  null &&
                                              difference(
                                                      studentModel.birthDate ??
                                                          '2000-10-10') ==
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
                                          visible: studentModel.birthDate !=
                                                  null &&
                                              difference(
                                                      studentModel.birthDate ??
                                                          '2000-10-10') ==
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
                                          visible:
                                              studentModel.birthDate != null &&
                                                  difference(studentModel
                                                                  .birthDate ??
                                                              '2000-10-10')
                                                          .abs() >
                                                      1,
                                          child: Expanded(
                                            child: MyText(
                                              '${difference(studentModel.birthDate ?? '2000-10-10') > 0 ? tr('left') : tr('ago')} ${difference(studentModel.birthDate ?? '2000-10-10').abs()}  ${tr('day')}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : MyText(
                                      AppString.birthdate_not_registered,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: AppColors.red,
                                          ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      AttendCaller(studentModel: studentModel),
                      QRCode(
                        studentModel: studentModel,
                        device: device,
                      ),
                    ],
                  ),
                ),
              );
            case DeviceType.tablet:
            case DeviceType.desktop:
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: CircleAvatar(
                                    maxRadius: 40,
                                    minRadius: 10,
                                    child: Center(
                                      child: Text(
                                        studentModel.academicYear.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  studentModel.code,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AddStudentDialog(
                                                    edit: true,
                                                    student: studentCubit
                                                            .studentModel[
                                                        studentModel.id],
                                                  );
                                                },
                                              );
                                              pop(context);
                                            },
                                            icon: const Icon(
                                              AppIcons.edit,
                                              color: AppColors.green,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              // StudentCubit.get(context)
                                              //     .deleteStudent(studentModel
                                              //         .indexAtDatabase);
                                              pop(context);
                                            },
                                            icon: const Icon(
                                              AppIcons.delete,
                                              color: AppColors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              studentModel.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if(studentModel.phone !=  null && studentModel.phone != ''){
                                                studentCubit.callPhone(studentModel.phone ?? '');
                                              }else{
                                                MyToast(msg: AppString.phone_not_found, state: ToastStates.WARNING);
                                              }
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                (studentModel.phone != null &&
                                                        studentModel.phone !=
                                                            '')
                                                    ? Text(
                                                        studentModel.phone ??
                                                            '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall,
                                                      )
                                                    : MyText(
                                                        AppString
                                                            .phone_not_found,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .copyWith(
                                                                color: AppColors
                                                                    .red),
                                                      ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Icon(
                                                  AppIcons.phone,
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    AttendCaller(
                                      studentModel: studentModel,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            QRCode(studentModel: studentModel, device: device),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              //// activity
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MyText(
                                    AppString.activity,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  ListView.builder(
                                    itemBuilder: (context, index) {
                                      return MenuCard(
                                        icon: AppIcons.circle,
                                        cardName: activity[index].name,
                                        restCard: const SizedBox(),
                                      );
                                    },
                                    shrinkWrap: true,
                                    itemCount: activity.length,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              //// points
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        MyText(
                                          AppString.points,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        // CircleAvatar(
                                        //   maxRadius: 15,
                                        //   child: Text(
                                        //     studentCubit
                                        //         .studentPoints(
                                        //             studentModel.points)
                                        //         .toString(),
                                        //     style: Theme.of(context)
                                        //         .textTheme
                                        //         .titleSmall!
                                        //         .copyWith(
                                        //             color: AppColors.black),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    itemBuilder: (context, index) {
                                      return MenuCard(
                                        icon: AppIcons.circle,
                                        cardName: act[index].name,
                                        restCard: Text(
                                          studentModel.points![index].value
                                              .toString(),
                                        ),
                                      );
                                    },
                                    shrinkWrap: true,
                                    itemCount: act.length,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
          }
        }),
      );
    });
  }
}
