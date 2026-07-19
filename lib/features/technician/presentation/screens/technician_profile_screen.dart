import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/application/cerca_controller.dart';
import '../../../cerca/presentation/widgets/back_circle_button.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../cerca/presentation/widgets/verified_badge.dart';
import '../../application/providers_controller.dart';
import '../../domain/tech_team.dart';

class _ProfileView {
  const _ProfileView({
    required this.mono,
    required this.name,
    required this.oficio,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.priceLabel,
    this.team,
  });

  final String mono;
  final String name;
  final String oficio;
  final String distance;
  final double rating;
  final int reviews;
  final String priceLabel;
  final TechTeam? team;
}

class TechnicianProfileScreen extends ConsumerWidget {
  const TechnicianProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cercaControllerProvider);
    final providersAsync = ref.watch(providersControllerProvider);
    final providersPage = providersAsync.value;

    _ProfileView? profile;
    if (providersPage != null) {
      if (state.viewingTeam) {
        for (final t in providersPage.teams) {
          if (t.id == state.selectedTeamId) {
            profile = _ProfileView(mono: t.mono, name: t.name, oficio: t.oficio, distance: t.distance, rating: t.rating, reviews: t.reviews, priceLabel: t.priceLabel, team: t);
            break;
          }
        }
      } else {
        for (final t in providersPage.technicians) {
          if (t.id == state.selectedTechId) {
            profile = _ProfileView(mono: t.mono, name: t.name, oficio: t.oficio, distance: t.distance, rating: t.rating, reviews: t.reviews, priceLabel: t.priceLabel);
            break;
          }
        }
      }
    }

    if (profile == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: providersAsync.isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('No se pudo cargar este perfil.', style: CercaText.sora(fontSize: 14)),
                      const SizedBox(height: 12),
                      TextButton(onPressed: () => context.go(RoutePaths.home), child: const Text('Volver')),
                    ],
                  ),
          ),
        ),
      );
    }

    final provider = profile;
    final isTeam = provider.team != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 110,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.cercaPrimary, AppColors.cercaPrimaryGradientEnd],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: BackCircleButton(
                            onTap: () => context.go(RoutePaths.home),
                            color: Colors.white.withValues(alpha: 0.25),
                            iconColor: Colors.white,
                            border: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -37),
                          child: Container(
                            width: 74,
                            height: 74,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.cercaSurfaceTint,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.cercaBackground, width: 4),
                            ),
                            child: Text(provider.mono, style: CercaText.sora(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.cercaPrimary)),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -27),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(provider.name, style: CercaText.lora(fontSize: 20)),
                                  const SizedBox(width: 8),
                                  const VerifiedBadge(),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text('${provider.oficio} · ${provider.distance} de ti', style: CercaText.sora(fontSize: 13, color: AppColors.cercaTextSecondary)),
                              const SizedBox(height: 4),
                              Text.rich(
                                TextSpan(
                                  style: CercaText.sora(fontSize: 13),
                                  children: [
                                    TextSpan(text: '★ ', style: CercaText.sora(fontSize: 13, color: AppColors.cercaStar)),
                                    TextSpan(text: '${provider.rating} '),
                                    TextSpan(
                                      text: '(${provider.reviews} reseñas)',
                                      style: CercaText.sora(fontSize: 13, color: AppColors.cercaTextMuted),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (provider.team case TechTeam(:final crew, :final projects))
                                _StatsRow(items: [
                                  _Stat('$crew', 'Integrantes'),
                                  _Stat('$projects', 'Proyectos'),
                                  const _Stat('48h', 'Visita técnica'),
                                ])
                              else
                                const _StatsRow(items: [
                                  _Stat('312', 'Trabajos'),
                                  _Stat('6 años', 'Experiencia'),
                                  _Stat('18 min', 'Respuesta'),
                                ]),
                              const SizedBox(height: 16),
                              Text('Documentación verificada', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              const _CheckLine('Cédula de identidad'),
                              const _CheckLine('Certificado de antecedentes'),
                              const _CheckLine('Certificado de especialidad'),
                              const SizedBox(height: 16),
                              Text('Tarifa referencial', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text(
                                '${provider.priceLabel} · visita técnica desde S/ 20',
                                style: CercaText.sora(fontSize: 13, color: AppColors.cercaTextSecondary),
                              ),
                              const SizedBox(height: 16),
                              Text('Trabajos anteriores', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _PastJobTile(color: AppColors.cercaBorder)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _PastJobTile(color: AppColors.cercaSurfaceTint)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _PastJobTile(color: AppColors.cercaBorder)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text('Reseñas', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              const _ReviewCard(author: 'Camila R.', text: 'Llegó puntual y dejó todo funcionando. Muy profesional.'),
                              const SizedBox(height: 8),
                              const _ReviewCard(author: 'Rodrigo T.', text: 'Buen precio y explicó todo antes de empezar.'),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.cercaBorder))),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go(RoutePaths.chat),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.cercaPrimary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Chatear', style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.cercaPrimary)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => isTeam ? context.go(RoutePaths.jobProjectQuote) : context.go(RoutePaths.jobDirect),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cercaPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        isTeam ? 'Cotizar proyecto' : 'Solicitar cotización',
                        style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.items});
  final List<_Stat> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: items[i]),
        ],
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cercaBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: CercaText.sora(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: CercaText.sora(fontSize: 10, color: AppColors.cercaTextSecondary)),
        ],
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  const _CheckLine(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Text('✓', style: TextStyle(color: AppColors.cercaSuccessText, fontSize: 12.5)),
          const SizedBox(width: 8),
          Text(label, style: CercaText.sora(fontSize: 12.5)),
        ],
      ),
    );
  }
}

class _PastJobTile extends StatelessWidget {
  const _PastJobTile({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.author, required this.text});
  final String author;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cercaBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              style: CercaText.sora(fontSize: 12.5, fontWeight: FontWeight.w600),
              children: [
                TextSpan(text: '$author '),
                TextSpan(text: '★★★★★', style: CercaText.sora(fontSize: 12.5, fontWeight: FontWeight.w400, color: AppColors.cercaStar)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(text, style: CercaText.sora(fontSize: 12, color: AppColors.cercaTextSecondary, height: 1.4)),
        ],
      ),
    );
  }
}
