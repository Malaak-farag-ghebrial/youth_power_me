import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:youth_power/core/constants/app_colors.dart';

class MyInputField extends StatelessWidget {
  final TextEditingController controller;
  final double maxHeight;
  final Color fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final bool showLabel;
  final Function()? onTap;
  final Function(String value)? onChanged;
  final TextInputType keyboardType;

  const MyInputField({
    super.key,
    required this.controller,
    this.maxHeight = 50,
    this.fillColor = AppColors.mainOpacity,
    this.prefixIcon,
    this.hintText = '',
    this.showLabel = false,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          controller: controller,
          textAlignVertical: prefixIcon != null || suffixIcon != null ? TextAlignVertical.center : TextAlignVertical.top,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxHeight: maxHeight),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            filled: true,
            fillColor: fillColor,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hintText.tr(),
            labelText: showLabel ? hintText.tr() : null,
            hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
              fontSize: 15,
            ),
            alignLabelWithHint: false,
            border: InputBorder.none,
          ),
          maxLines: null,
          keyboardType: keyboardType,
          onTap: onTap,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
