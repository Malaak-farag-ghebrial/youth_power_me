import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/component/my_button.dart';
import '../../../../../core/component/my_dialog.dart';
import '../../../../../core/component/my_input_field.dart';
import '../../../../../core/component/my_indicator.dart';
import '../../../../../core/component/my_navigator.dart';
import '../../../../../core/component/my_text.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../controller/student_cubit/student_cubit.dart';
import '../../../../controller/week_cubit/week_cubit.dart';
import '../../../../model/activity.dart';
import '../../../../model/week.dart';
import '../../../student/screens/nearest_birth_date_list.dart';
import '../../widgets/attend_student_card.dart';
import 'activity_absents.dart';

class ActivityAttendance extends StatefulWidget {
  final WeekModel weekModel;
  final ActivityModel activityModel;

  const ActivityAttendance(
      {super.key, required this.weekModel, required this.activityModel});

  @override
  State<ActivityAttendance> createState() => _ActivityAttendanceState();
}

class _ActivityAttendanceState extends State<ActivityAttendance> {
  final searchController = TextEditingController();

  // QRViewController? qrViewController;
  // Barcode? barcode;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     qrViewController!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     qrViewController!.resumeCamera();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
      buildWhen: (p, n) {
        return n is SearchStudentSuccess || n is ScanStudentCodeSuccess;
      },
      builder: (context, studentState) {
        var studentCubit = StudentCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title:
                Text('${widget.weekModel.date} - ${widget.activityModel.name}'),
          ),
          body: Column(
            children: [
              MyInputField(
                controller: searchController,
                onChanged: (value) {
                  studentCubit.searchStudent(searchWord: value);
                },
                hintText: AppString.search,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: studentState is FilterBirthDateStudentLoading
                        ? const MyIndicator()
                        : MyOutlinedButton(
                            textWord: AppString.birth_date,
                            hasBorder: true,
                            borderColor: AppColors.primaryColor,
                            fontSize: 15,
                            borderWidth: 2,
                            buttonHeight: 40,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              StudentCubit.get(context).filterBirthDateStudent(
                                  startTime:
                                      DateTime.parse(widget.weekModel.date)
                                          .subtract(const Duration(days: 7)),
                                  endTime: DateTime.parse(widget.weekModel.date)
                                      .add(const Duration(days: 7)));

                                navigateTo(context, NearestBirthDateStudent());
                            },
                          ),
                  ),
                  Expanded(
                    child: studentState is FilterAbsentStudentLoading
                        ? const MyIndicator()
                        : MyOutlinedButton(
                            textWord: AppString.absent,
                            fontSize: 15,
                            hasBorder: true,
                            borderColor: AppColors.primaryColor,
                            borderWidth: 2,
                            buttonHeight: 40,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              StudentCubit.get(context).filterAbsentStudent(
                                  week: WeekCubit.get(context)
                                      .weekModel
                                      .firstWhere(
                                          (e) => e.id == widget.weekModel.id),
                                  activity: widget.activityModel);
                              navigateTo(context, ActivityAbsents(week: widget.weekModel));
                            },
                          ),
                  )
                ],
              ),
              studentCubit.studentModel.isEmpty ||
                      studentState is GetStudentLoading
                  ? const MyIndicator()
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: studentCubit.searchStudentModel.length,
                        itemBuilder: (context, index) {
                          return AttendanceStudentCard(
                            studentModel:
                                studentCubit.searchStudentModel[index],
                            weekModel: widget.weekModel,
                            activityModel: widget.activityModel,
                          );
                        },
                      ),
                    ),

              //   Text(barcode != null ? barcode!.code.toString() : 'barcode data'),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return BlocBuilder<StudentCubit, StudentState>(
                      builder: (context, state) {
                    return MyDialog(
                      title: AppString.scan,
                      acceptWord: AppString.ok,
                      maxHeight: 500,
                      accept: () {
                        // WeekCubit.get(context).attendActivityStudent(
                        //   weekId: widget.weekModel.id ?? 0,
                        //   stId: studentCubit.scannedStudent!.id,
                        //   actId: widget.activityModel.id ?? 0,
                        //   attendTime: arabicToEnglish(DateFormat('h:mm a').format(DateTime.now()).toString()),
                        // );
                        // studentCubit.attendStudent(
                        //   week: widget.weekModel.date,
                        //   studentIndex:
                        //       studentCubit.scannedStudent!.indexAtDatabase,
                        //   act: widget.activityModel,
                        //   attendTime: arabicToEnglish(DateFormat('h:mm a').format(DateTime.now()).toString()),
                        // );
                        pop(context);
                      },
                      widget: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              //  await qrViewController!.toggleFlash();
                            },
                            icon: const Icon(
                              AppIcons.flash,
                              color: AppColors.amber,
                            ),
                          ),
                          const MyText(
                            AppString.under_development,
                          ),
                          // SizedBox(
                          //   width: 300,
                          //   height: 300,
                          //   child: QRView(
                          //       key: qrKey,
                          //       overlay: QrScannerOverlayShape(
                          //         borderRadius: 10,
                          //         borderColor: AppColors.gold,
                          //         borderWidth: 10,
                          //         borderLength: 20,
                          //       ),
                          //       onQRViewCreated: (QRViewController controller) {
                          //         qrViewController = controller;
                          //         controller.scannedDataStream.listen((scanData) {
                          //           GlobalFunction.print(scanData.code.toString(),
                          //               name: 'barcode data : ');
                          //           setState(() {
                          //             barcode = scanData;
                          //             studentCubit.scanStudent(
                          //                 code: scanData.code ?? '');
                          //           });
                          //         });
                          //       }),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // state is ScanStudentCodeLoading
                          //     ? const MyIndicator()
                          //     : barcode != null
                          //         ? Text(studentCubit.scannedStudent != null
                          //             ? studentCubit.scannedStudent!.name
                          //                 .toString()
                          //             : AppString.not_found.tr())
                          //         : const SizedBox(),
                        ],
                      ),
                    );
                  });
                },
              );
            },
            label: const Icon(AppIcons.barcode),
          ),
        );
      },
    );
  }
}
