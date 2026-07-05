import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';

/// A single "Continuar con {provider}" row used on the Register screen.
class SocialProviderButton extends StatelessWidget {
  const SocialProviderButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.icon,
    required this.iconBackground,
    this.iconBorder,
    this.trailing,
  });

  final String label;
  final VoidCallback onTap;
  final Widget icon;
  final Color iconBackground;
  final Color? iconBorder;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.cercaBorder),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.cercaTextPrimary.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBackground,
                border: iconBorder != null ? Border.all(color: iconBorder!) : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: icon,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: CercaText.sora(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
