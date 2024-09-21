import 'package:flutter/material.dart';
import 'package:youth_power/core/component/my_button.dart';
import 'package:youth_power/core/component/my_navigator.dart';
import 'package:youth_power/core/component/my_text.dart';
import 'package:youth_power/core/constants/app_colors.dart';
import 'package:youth_power/core/constants/app_strings.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final Widget widget;
  final double maxHeight;
  final double maxWidth;
  final Function()? accept;
  final String? acceptWord;

  const MyDialog({
    super.key,
    required this.title,
    required this.widget,
    this.maxHeight = 450,
    this.maxWidth = 350,
    this.accept,
    this.acceptWord = AppString.add,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          maxWidth: maxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          child: ListView(
            shrinkWrap: true,
            children: [
              MyText(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              widget,
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: accept == null ? false : true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: MyElevatedButton(
                        color: AppColors.primaryColorLight,
                        onTap: accept,
                        child: MyText(
                          acceptWord!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MyOutlinedButton(
                        textWord: AppString.cancel,
                        fontSize: 16,
                        onTap: () {
                          pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
