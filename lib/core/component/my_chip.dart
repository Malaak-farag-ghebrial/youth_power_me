
import 'package:flutter/material.dart';
import 'package:youth_power/core/component/shadow_box.dart';
import 'package:youth_power/core/constants/app_colors.dart';

class SmallChip extends StatelessWidget {
  final BoxBorder? border;
  final Widget child;
  final Color? color;

   const SmallChip({super.key, this.border, required this.child,this.color = AppColors.primaryColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5,
      ),
      decoration: BoxDecoration(
          color: color,
          boxShadow: boxShadow(),
          border: border,
          borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }
}