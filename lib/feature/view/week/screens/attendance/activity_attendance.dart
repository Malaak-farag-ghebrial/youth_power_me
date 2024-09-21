import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/component/my_dialog.dart';
import '../../../../../core/component/my_input_field.dart';
import '../../../../../core/component/my_indicator.dart';
import '../../../../../core/component/my_navigator.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/functions/arabic_to_english_number.dart';
import '../../../../../core/functions/global_variable.dart';
import '../../../../controller/student_cubit/student_cubit.dart';
import '../../../../model/activity.dart';
import '../../../../model/week.dart';
import '../../widgets/attend_student_card.dart';

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

    //     buildWhen: (p, n) {
    //   return n is AddPointStudentSuccess ||
    //       n is SearchStudentSuccess ||
    //       n is ScanStudentCodeSuccess;
    // },
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
            studentCubit.studentModel.isEmpty ||
                    studentState is GetStudentLoading
                ? const MyIndicator()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: studentCubit.searchStudentModel.length,
                    itemBuilder: (context, index) {
                      return AttendanceStudentCard(
                        studentModel: studentCubit.searchStudentModel[index],
                        weekModel: widget.weekModel,
                        activityModel: widget.activityModel,
                      );
                    },
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
                      //   weekIndex: widget.weekModel.indexAtDatabase,
                      //   studentId: studentCubit.scannedStudent!.id,
                      //   actId: widget.activityModel.id,
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
    });
  }
}
