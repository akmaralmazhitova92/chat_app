import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color? color;
  final Color? textColor;
  final Color? splashColor;
  final Function() onTap;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
    this.textColor,
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: splashColor ?? AppColors.black, // Set splash color
      borderRadius: BorderRadius.circular(18), // Set border radius for InkWell
      child: Ink(
        height: 56,
        width: 300,
        decoration: BoxDecoration(
          color: color ?? AppColors.red,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyles.font18.copyWith(color: textColor ?? AppColors.white),
          ),
        ),
      ),
    );
  }
}