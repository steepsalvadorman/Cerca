import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/router/back_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/application/cerca_controller.dart';
import '../../../cerca/presentation/widgets/cerca_header.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../cerca/presentation/widgets/monogram_avatar.dart';
import '../../../cerca/presentation/widgets/primary_action_button.dart';
import '../../../cerca/presentation/widgets/verified_badge.dart';
import '../../../technician/application/providers_controller.dart';
import '../../../technician/domain/technician.dart';
import '../../application/client_history_controller.dart';
import '../../application/job_session_controller.dart';
import '../widgets/job_address_field.dart';

class DirectQuoteScreen extends ConsumerStatefulWidget {
  const DirectQuoteScreen({super.key});

  @override
  ConsumerState<DirectQuoteScreen> createState() => _DirectQuoteScreenState();
}

class _DirectQuoteScreenState extends ConsumerState<DirectQuoteScreen> {
  bool _sending = false;
  final _descriptionController = TextEditingController();
  String? _address;
  String? _descriptionError;
  String? _addressError;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(serviceRequestDraftProvider);
    _descriptionController.text = draft.description;
    _address = draft.address;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// Creates the direct job with what the client actually told us. Nothing
  /// here is a quote yet: price and arrival time come from the technician,
  /// in the chat, once they have read the request.
  Future<void> _sendRequest(Technician provider) async {
    if (_sending) return;
    final description = _descriptionController.text.trim();
    setState(() {
      _descriptionError = description.isEmpty ? 'Cuéntale a ${provider.name.split(' ').first} qué necesitas.' : null;
      _addressError = (_address == null || _address!.isEmpty) ? 'Indica dónde es el trabajo.' : null;
    });
    if (_descriptionError != null || _addressError != null) return;

    setState(() => _sending = true);
    try {
      final draft = ref.read(serviceRequestDraftProvider);
      final label = draft.categoryLabel ?? provider.oficio;
      final job = await ref.read(jobRepositoryProvider).createJob(
            technicianProfileId: provider.id,
            jobKind: 'direct',
            title: '$label: $description',
            address: _address,
          );
      ref.read(jobSessionControllerProvider.notifier).setJobId(job.id);
      ref.invalidate(clientHistoryProvider);
      ref.read(cercaControllerProvider.notifier).acceptDirect();
      if (!mounted) return;
      context.go(RoutePaths.tracking);
    } catch (e) {
      if (!mounted) return;
      final message = e is ApiException ? e.message : 'No se pudo enviar la solicitud. Revisa tu conexión e inténtalo de nuevo.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cercaState = ref.watch(cercaControllerProvider);
    final providersAsync = ref.watch(providersControllerProvider);
    final providersPage = providersAsync.value;

    Technician? provider;
    if (providersPage != null) {
      for (final t in providersPage.technicians) {
        if (t.id == cercaState.selectedTechId) {
          provider = t;
          break;
        }
      }
    }

    if (provider == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: providersAsync.isLoading
                ? const CircularProgressIndicator()
                : TextButton(onPressed: () => context.goBack(RoutePaths.home), child: const Text('Volver')),
          ),
        ),
      );
    }
    final tech = provider;
    final firstName = tech.name.split(' ').first;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CercaHeader(title: 'Solicitar a $firstName', onBack: () => context.goBack(RoutePaths.providerProfile)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.cercaBorder),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          MonogramAvatar(text: tech.mono, size: 44, borderRadius: 12, fontSize: 14),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 6,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(tech.name, style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w600)),
                                    if (tech.isVerified) const VerifiedBadge(),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${tech.oficio} · tarifa referencial ${tech.priceLabel.replaceFirst('Desde', 'desde')}',
                                  style: CercaText.sora(fontSize: 12, color: AppColors.cercaTextSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('¿Qué necesitas?', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      minLines: 3,
                      maxLines: 5,
                      maxLength: 180,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_) {
                        if (_descriptionError != null) setState(() => _descriptionError = null);
                      },
                      decoration: InputDecoration(
                        hintText: 'Describe el problema y desde cuándo ocurre',
                        errorText: _descriptionError,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    JobAddressField(
                      value: _address,
                      errorText: _addressError,
                      onChanged: (value) => setState(() {
                        _address = value;
                        _addressError = null;
                      }),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cercaBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$firstName recibirá tu solicitud y te responderá por chat con su precio y horario. No pagas nada por enviarla.',
                        style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PrimaryActionButton(
              label: _sending ? 'Enviando…' : 'Enviar solicitud a $firstName',
              enabled: !_sending,
              onTap: () => _sendRequest(tech),
            ),
          ],
        ),
      ),
    );
  }
}
