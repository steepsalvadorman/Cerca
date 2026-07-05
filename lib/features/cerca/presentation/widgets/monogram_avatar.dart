import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Rounded-square avatar showing a person's/team's initials, used across
/// lists, headers and chat bubbles wherever the prototype used a colored
/// monogram square instead of a photo.
class MonogramAvatar extends StatelessWidget {
  const MonogramAvatar({
    super.key,
    required this.text,
    this.size = 44,
    this.borderRadius = 12,
    this.fontSize = 15,
    this.background = AppColors.cercaSurfaceTint,
    this.foreground = AppColors.cercaPrimary,
  });

  final String text;
  final double size;
  final double borderRadius;
  final double fontSize;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
