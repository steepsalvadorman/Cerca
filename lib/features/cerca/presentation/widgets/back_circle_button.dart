import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The circular "‹" back button used at the top of nearly every Cerca
/// screen, navigating to an explicit target rather than popping a stack
/// (the prototype's screens are flat, not push-based).
class BackCircleButton extends StatelessWidget {
  const BackCircleButton({
    super.key,
    required this.onTap,
    this.color = Colors.white,
    this.iconColor = AppColors.cercaTextPrimary,
    this.border = true,
  });

  final VoidCallback onTap;
  final Color color;
  final Color iconColor;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: border ? Border.all(color: AppColors.cercaBorder) : null,
        ),
        child: Text(
          '‹',
          style: TextStyle(color: iconColor, fontSize: 15),
        ),
      ),
    );
  }
}
