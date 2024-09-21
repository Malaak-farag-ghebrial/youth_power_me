import 'package:flutter/material.dart';
import 'package:youth_power/core/constants/app_colors.dart';

class MyIndicator extends StatelessWidget {
  final bool small;
  final Color color;


  const MyIndicator({super.key, this.small = true, this.color = AppColors.primaryColor,});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: small ? 15 : null,
        height: small ? 15 : null,
        child: CircularProgressIndicator(strokeWidth: small ? 2 : 4,color: color,),),
    );
  }
}

