import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Bienvenido\notra vez',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
        height: 35 / 40,
        color: AppColors.primaryBlue,
      ),
    );
  }
}
