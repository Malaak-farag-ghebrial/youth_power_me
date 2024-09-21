import 'package:flutter/material.dart';
import 'package:youth_power/core/component/my_button.dart';
import 'package:youth_power/core/component/my_navigator.dart';
import 'package:youth_power/core/component/my_text.dart';
import 'package:youth_power/core/constants/app_colors.dart';
import 'package:youth_power/core/constants/app_strings.dart';

class WarningDialog extends StatelessWidget {
  final String warning;
  final Widget? widget;
  final String acceptWord;
  final String cancelWord;
  final Function()? onTap;
  final Function()? cancel;

  const WarningDialog(
      {super.key,
      required this.warning,
        this.widget,
      this.acceptWord = AppString.ok,
      this.cancelWord = AppString.cancel,
      this.onTap,
      this.cancel ,});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Builder(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              MyText(warning,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10,),
              widget ?? const SizedBox(),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: MyElevatedButton(
                      onTap: onTap,
                      child: MyText(
                        acceptWord,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 12,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  MyOutlinedButton(
                      textWord: cancelWord,
                      weight: FontWeight.w600,
                      borderColor: AppColors.primaryColor,
                      borderWidth: 1.5,
                      hasBorder: true,
                      buttonHeight: 45,
                      buttonWidth: 80,
                      borderRadius: BorderRadius.circular(10),
                      onTap: cancel ?? () {
                        pop(context);
                      }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        },
      ),
    );
  }
}
