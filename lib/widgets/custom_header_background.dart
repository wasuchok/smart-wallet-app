import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomHeaderBackground extends StatelessWidget {
  final double height;
  final double borderRadius;

  const CustomHeaderBackground({
    super.key,
    required this.height,
    this.borderRadius = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      ),
    );
  }
}
