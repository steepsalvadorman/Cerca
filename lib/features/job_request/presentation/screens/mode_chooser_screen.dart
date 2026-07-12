import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/presentation/widgets/back_circle_button.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../application/job_session_controller.dart';

class ModeChooserScreen extends ConsumerStatefulWidget {
  const ModeChooserScreen({super.key});

  @override
  ConsumerState<ModeChooserScreen> createState() => _ModeChooserScreenState();
}

class _ModeChooserScreenState extends ConsumerState<ModeChooserScreen> {
  bool _creating = false;

  Future<void> _startBidding() async {
    if (_creating) return;
    setState(() => _creating = true);
    try {
      final job = await ref.read(jobRepositoryProvider).createJob(jobKind: 'bidding');
      ref.read(jobSessionControllerProvider.notifier).setJobId(job.id);
      if (!mounted) return;
      context.go(RoutePaths.jobBidding);
    } catch (e) {
      if (!mounted) return;
      final message = e is ApiException ? e.message : 'No se pudo publicar el trabajo.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
              child: Row(
                children: [
                  BackCircleButton(onTap: () => context.go(RoutePaths.home)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¿Cómo prefieres resolverlo?', style: CercaText.lora(fontSize: 21)),
                    const SizedBox(height: 4),
                    Text(
                      'Instalar termo eléctrico · Providencia',
                      style: CercaText.sora(fontSize: 13, color: AppColors.cercaTextSecondary, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    _OptionCard(
                      number: '1',
                      title: 'Contactar directo',
                      description: 'Elige un técnico cercano en el mapa y coordina un precio directamente con él.',
                      cta: 'Ver técnicos cercanos ›',
                      onTap: () => context.go(RoutePaths.home),
                    ),
                    const SizedBox(height: 14),
                    _OptionCard(
                      number: '2',
                      title: 'Licitación entre técnicos',
                      description: 'Publica el trabajo y recibe ofertas de varios técnicos verificados. Elige la mejor combinación de precio y calidad.',
                      cta: _creating ? 'Publicando…' : 'Publicar trabajo ›',
                      onTap: _startBidding,
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

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.number,
    required this.title,
    required this.description,
    required this.cta,
    required this.onTap,
  });

  final String number;
  final String title;
  final String description;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.cercaBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.cercaSurfaceTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(number, style: CercaText.sora(fontWeight: FontWeight.w700, color: AppColors.cercaPrimary)),
            ),
            Text(title, style: CercaText.sora(fontSize: 15.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(description, style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary, height: 1.5)),
            const SizedBox(height: 10),
            Text(cta, style: CercaText.sora(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.cercaPrimary)),
          ],
        ),
      ),
    );
  }
}
