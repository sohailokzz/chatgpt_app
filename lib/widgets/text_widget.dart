import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final Color? fontColor;
  final FontWeight? fontWeight;
  const TextWidget({
    super.key,
    required this.label,
    this.fontSize = 18,
    this.fontColor,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: fontColor ?? Colors.white,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontSize: fontSize,
      ),
    );
  }
}
