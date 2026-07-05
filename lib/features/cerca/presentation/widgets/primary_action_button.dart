import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The full-width pill CTA anchored at the bottom of most Cerca screens,
/// above a top border separating it from the scrollable content.
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.showTopBorder = true,
  });

  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
      decoration: BoxDecoration(
        border: showTopBorder
            ? const Border(top: BorderSide(color: AppColors.cercaBorder))
            : null,
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? AppColors.cercaPrimary : const Color(0xFFC9B8B4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
