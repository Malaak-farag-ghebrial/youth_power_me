
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../core/component/my_text.dart';
import '../../../../core/component/my_toast.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/model/device_info.dart';
import '../../../model/student.dart';

class QRCode extends StatelessWidget {
  final StudentModel studentModel;
  final DeviceInfo device;
   QRCode({super.key, required this.studentModel, required this.device});

  final ScreenshotController screenshotController = ScreenshotController();

  _downloadQrCode({required String name}) async {
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        // WebImageDownloader.downloadImageFromUInt8List(
        //   uInt8List: image,
        //   name: name,
        // );
      }
    }).catchError((error) {
      MyToast(msg: AppString.some_thing_error, state: ToastStates.FAILED);
    });
  }
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                insetPadding: EdgeInsets.zero,
                elevation: 50,
                child: Container(
                  color: AppColors.whiteColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QrImageView(
                        data: studentModel.code,
                        size: device.localWidth,
                        backgroundColor: AppColors.whiteColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          '${studentModel.name} - ${studentModel.code}'),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: kIsWeb,
                        child: TextButton(
                          onPressed: () {
                            _downloadQrCode(
                                name:
                                '${studentModel.name} - ${studentModel.code}');
                          },
                          child: MyText(AppString.download),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          height: 250,
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              color: AppColors.whiteColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QrImageView(
                    data: studentModel.code,
                    size: 200,
                    backgroundColor: AppColors.whiteColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      '${studentModel.name} - ${studentModel.code}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
