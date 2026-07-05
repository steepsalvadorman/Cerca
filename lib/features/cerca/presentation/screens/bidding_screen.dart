import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/cerca_controller.dart';
import '../../application/cerca_format.dart';
import '../../application/cerca_seed_data.dart';
import '../../application/cerca_state.dart';
import '../../domain/entities/job_offer.dart';
import '../widgets/cerca_header.dart';
import '../widgets/cerca_text_styles.dart';
import '../widgets/monogram_avatar.dart';

class BiddingScreen extends ConsumerWidget {
  const BiddingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cercaControllerProvider);
    final controller = ref.watch(cercaControllerProvider.notifier);
    final offers = controller.sortedOffers;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CercaHeader(title: 'Ofertas recibidas', onBack: () => context.go(RoutePaths.jobMode)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instalar termo eléctrico · publicado hace 10 min · ${CercaSeedData.offers.length} ofertas',
                      style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _SortChip(
                          label: 'Menor precio',
                          active: state.sortBy == SortBy.price,
                          onTap: () => controller.setSort(SortBy.price),
                        ),
                        const SizedBox(width: 8),
                        _SortChip(
                          label: 'Mejor calificación',
                          active: state.sortBy == SortBy.rating,
                          onTap: () => controller.setSort(SortBy.rating),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    for (final offer in offers)
                      _OfferCard(
                        offer: offer,
                        onChat: () => context.go(RoutePaths.chat),
                        onChoose: () {
                          controller.chooseOffer();
                          context.go(RoutePaths.jobFee);
                        },
                      ),
                    Text(
                      'Al elegir una oferta, Cerca cobra una tarifa de licitación. El pago del trabajo se acuerda directo con el técnico.',
                      textAlign: TextAlign.center,
                      style: CercaText.sora(fontSize: 11, color: AppColors.cercaTextMuted, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.cercaPrimary : Colors.white,
          border: Border.all(color: active ? AppColors.cercaPrimary : AppColors.cercaBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: CercaText.sora(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.cercaTextPrimary),
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer, required this.onChat, required this.onChoose});
  final JobOffer offer;
  final VoidCallback onChat;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: offer.verified ? AppColors.cercaBorder : AppColors.cercaUnverifiedBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              MonogramAvatar(text: offer.mono, size: 38, borderRadius: 10, fontSize: 13),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(offer.name, style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                          decoration: BoxDecoration(
                            color: offer.verified ? AppColors.cercaSurfaceTint : AppColors.cercaWarnBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            offer.verified ? '✓ Verificado' : 'Sin verificar',
                            style: CercaText.sora(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: offer.verified ? AppColors.cercaPrimary : AppColors.cercaWarnTextStrong,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaTextSecondary),
                        children: [
                          TextSpan(text: '${offer.oficio} · '),
                          TextSpan(text: '★', style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaStar)),
                          TextSpan(text: ' ${offer.rating}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(formatClp(offer.price), style: CercaText.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(offer.eta, style: CercaText.sora(fontSize: 10.5, color: AppColors.cercaTextSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onChat,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.cercaBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                  child: Text('Chatear', style: CercaText.sora(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onChoose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cercaPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                  child: Text('Elegir', style: CercaText.sora(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
