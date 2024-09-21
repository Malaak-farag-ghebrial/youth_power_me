import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String dataTr; // translated string
  final String data; // untranslated string
  final bool flip;
  final TextStyle? style;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextAlign? textAlign;
  final int? maxLines;

  const MyText(
      this.dataTr,
      {
        super.key,
        this.data = '',
        this.flip = false,
        this.style,
        this.overflow,
        this.softWrap,
        this.textAlign,
        this.maxLines,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      flip ? '${dataTr.tr()}$data' : '$data${dataTr.tr()}',
      style: style,
      overflow: overflow,
      softWrap: softWrap,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}