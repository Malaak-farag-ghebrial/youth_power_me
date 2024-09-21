import 'package:flutter/material.dart';
import 'package:youth_power/core/component/my_text.dart';
import 'package:youth_power/core/component/shadow_box.dart';
import 'package:youth_power/core/constants/app_colors.dart';
import 'package:youth_power/core/constants/app_constant.dart';


class MyElevatedButton extends StatelessWidget {
  final Widget? child;
  final Function()? onTap;
  final Color color;

  const MyElevatedButton(
      {super.key, this.child, this.onTap, this.color = AppColors
          .primaryColor,});


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        boxShadow: boxShadow(),
        borderRadius: BorderRadius.circular(AppConstant.radius),
      ),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppConstant.radius),
              ),
            ),
          ),
          minimumSize: MaterialStateProperty.all(
            const Size(double.infinity, 42),
          ),
          backgroundColor: MaterialStateProperty.all(AppColors.transparent),
          shadowColor: MaterialStateProperty.all(AppColors.transparent),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}

class MyOutlinedButton extends StatelessWidget {
  final Color bgColor;
  final String textWord;
  final Color textColor;
  final Color borderColor;
  final FontWeight weight;
  final Function()? onTap;
  final double fontSize;
  final bool hasBorder;
  final double? buttonHeight;
  final double? buttonWidth;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;


  const MyOutlinedButton(
      {super.key,
         this.bgColor = AppColors.transparent,
        required this.textWord,
         this.textColor = AppColors.black,
        this.onTap,
         this.fontSize = 12,
         this.hasBorder = false,
        this.buttonHeight = 30,
        this.buttonWidth = 60,
        this.borderRadius,
        this.borderWidth,
         this.borderColor = AppColors.transparent,
         this.weight = FontWeight.bold,
        this.padding,
        this.margin,
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        width: buttonWidth,
        height: buttonHeight,
        decoration:
        BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
          border: (hasBorder)
              ? Border.all(color: borderColor, width: borderWidth!)
              : null,
        ),
        child: Center(
          child: MyText(
            textWord,
            style: TextStyle(
              fontSize: fontSize,
              fontStyle: FontStyle.normal,
              color: textColor,
              fontWeight: weight,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: true,
          ),),
      ),
    );
  }
}

