import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/cerca_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cercaBackground, AppColors.cercaSurfaceTint],
            stops: [0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.cercaPrimary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cercaPrimary.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text('C', style: CercaText.lora(fontSize: 28, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    Text('Cerca', style: CercaText.lora(fontSize: 26)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Técnicos verificados, cerca de ti. Encuentra ayuda de confianza para cualquier trabajo del hogar.',
                        textAlign: TextAlign.center,
                        style: CercaText.sora(
                          fontSize: 14.5,
                          color: AppColors.cercaTextSecondary,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    _RoleCard(
                      mono: 'H',
                      title: 'Soy Cliente',
                      subtitle: 'Necesito un técnico para un trabajo',
                      onTap: () => context.go(RoutePaths.home),
                    ),
                    const SizedBox(height: 12),
                    _RoleCard(
                      mono: 'T',
                      title: 'Soy Técnico',
                      subtitle: 'Quiero ofrecer mis servicios',
                      onTap: () => context.go(RoutePaths.techDocs),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.mono,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String mono;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.cercaBorder),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cercaTextPrimary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.cercaSurfaceTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                mono,
                style: CercaText.sora(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.cercaPrimary),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: CercaText.sora(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary)),
                ],
              ),
            ),
            Text('›', style: CercaText.sora(fontSize: 16, color: AppColors.cercaTextMuted)),
          ],
        ),
      ),
    );
  }
}
