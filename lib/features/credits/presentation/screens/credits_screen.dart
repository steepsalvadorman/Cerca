import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/router/back_navigation.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../cerca/presentation/widgets/cerca_header.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../cerca/presentation/widgets/primary_action_button.dart';
import '../../application/credits_controller.dart';
import '../../domain/credits_overview.dart';

/// Soles from céntimos, the way the rest of the app writes money.
String _soles(int cents) => 'S/ ${(cents / 100).toStringAsFixed(2)}';

/// Price of one credit when bought alone — the reference for "ahorras".
const _baseCentsPerCredit = 400;

/// A random v4 UUID: the purchase's idempotency key.
String _newPurchaseId() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-${hex.substring(20)}';
}

/// "Mis créditos": the technician's balance and the packs to top it up.
class CreditsScreen extends ConsumerStatefulWidget {
  const CreditsScreen({super.key});

  @override
  ConsumerState<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends ConsumerState<CreditsScreen> {
  String? _selectedPackId;

  Future<void> _buy(CreditsOverview overview, CreditPack pack) async {
    final result = await showModalBottomSheet<PurchaseResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _PaymentSheet(pack: pack, payments: overview.payments),
    );
    if (result == null || !mounted) return;
    ref.invalidate(creditsOverviewProvider);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        result.simulated
            ? 'Compra simulada: sumaste ${result.creditsAdded} créditos.'
            : '¡Listo! Sumaste ${result.creditsAdded} créditos.',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final overviewAsync = ref.watch(creditsOverviewProvider);
    final overview = overviewAsync.value;
    final packs = overview?.packs ?? const <CreditPack>[];
    final selected = packs.where((p) => p.id == _selectedPackId).firstOrNull ?? (packs.isEmpty ? null : packs.first);

    return Scaffold(
      backgroundColor: AppColors.cercaBackground,
      body: SafeArea(
        child: Column(
          children: [
            CercaHeader(title: 'Mis créditos', onBack: () => context.goBack(RoutePaths.technicianJobs)),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.refresh(creditsOverviewProvider.future),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: [
                    if (overviewAsync.isLoading && overview == null)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (overview == null)
                      _LoadError(onRetry: () => ref.invalidate(creditsOverviewProvider))
                    else ...[
                      _WalletCard(wallet: overview.wallet),
                      const SizedBox(height: 12),
                      if (overview.payments.isSimulated)
                        const _Notice(
                          icon: Icons.science_outlined,
                          text: 'Modo de prueba: las compras no cobran dinero real.',
                        )
                      else if (!overview.payments.isAvailable)
                        const _Notice(
                          icon: Icons.info_outline,
                          text: 'Las compras no están disponibles por ahora. Inténtalo más tarde.',
                        ),
                      const SizedBox(height: 8),
                      Semantics(
                        header: true,
                        child: Text('Recargar créditos', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      for (final pack in packs)
                        _PackOption(
                          pack: pack,
                          selected: pack.id == selected?.id,
                          onTap: () => setState(() => _selectedPackId = pack.id),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            if (overview != null && selected != null)
              PrimaryActionButton(
                label: 'Comprar ${selected.credits} créditos · ${_soles(selected.priceCents)}',
                enabled: overview.payments.isAvailable,
                onTap: () => _buy(overview, selected),
              ),
          ],
        ),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({required this.wallet});
  final CreditWallet wallet;

  @override
  Widget build(BuildContext context) {
    final empty = wallet.available == 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: empty ? AppColors.cercaWarnBorder : AppColors.cercaBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: '${wallet.available} créditos disponibles',
            excludeSemantics: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${wallet.available}', style: CercaText.lora(fontSize: 40, color: AppColors.cercaPrimary)),
                const SizedBox(width: 8),
                Text(
                  wallet.available == 1 ? 'crédito disponible' : 'créditos disponibles',
                  style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (wallet.reserved > 0) ...[
            const SizedBox(height: 2),
            Text(
              wallet.reserved == 1
                  ? '1 reservado por una oferta abierta'
                  : '${wallet.reserved} reservados por ofertas abiertas',
              style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            empty
                ? 'Necesitas al menos 1 crédito libre para enviar ofertas.'
                : 'Solo gastas 1 crédito cuando un cliente elige tu oferta. Si no ganas, no pagas.',
            style: CercaText.sora(
              fontSize: 12.5,
              color: empty ? AppColors.cercaWarnText : AppColors.cercaTextSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _PackOption extends StatelessWidget {
  const _PackOption({required this.pack, required this.selected, required this.onTap});
  final CreditPack pack;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final perCreditCents = (pack.priceCents / pack.credits).round();
    final savingPercent = ((1 - perCreditCents / _baseCentsPerCredit) * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        inMutuallyExclusiveGroup: true,
        checked: selected,
        button: true,
        label: '${pack.credits} créditos, ${_soles(pack.priceCents)}'
            '${savingPercent > 0 ? ', ahorras $savingPercent por ciento' : ''}',
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: selected ? AppColors.cercaSurfaceTint : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.cercaPrimary : AppColors.cercaBorder,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  size: 20,
                  color: selected ? AppColors.cercaPrimary : AppColors.cercaTextSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${pack.credits} créditos', style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(
                        '${_soles(perCreditCents)} por crédito${savingPercent > 0 ? ' · ahorras $savingPercent %' : ''}',
                        style: CercaText.sora(fontSize: 12, color: AppColors.cercaTextSecondary),
                      ),
                    ],
                  ),
                ),
                Text(_soles(pack.priceCents), style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cercaWarnBg,
        border: Border.all(color: AppColors.cercaWarnBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.cercaWarnText),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: CercaText.sora(fontSize: 12, color: AppColors.cercaWarnText, height: 1.4))),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No se pudieron cargar tus créditos. Revisa tu conexión e inténtalo de nuevo.',
            style: CercaText.sora(fontSize: 13, color: AppColors.cercaTextSecondary),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Reintentar'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48), padding: const EdgeInsets.symmetric(horizontal: 20)),
          ),
        ],
      ),
    );
  }
}

enum _Method { card, yape }

/// Collects the payment, turns it into a Culqi token on the device, and
/// asks the backend to charge it. Pops with the [PurchaseResult] on success.
class _PaymentSheet extends ConsumerStatefulWidget {
  const _PaymentSheet({required this.pack, required this.payments});
  final CreditPack pack;
  final PaymentsConfig payments;

  @override
  ConsumerState<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<_PaymentSheet> {
  _Method _method = _Method.card;
  bool _paying = false;
  String? _error;

  /// Kept for the whole sheet: a retry after a dropped connection reuses
  /// it, so the backend recognises the attempt instead of charging again.
  /// A *declined* payment gets a fresh one (that attempt is closed).
  String _purchaseId = _newPurchaseId();

  final _cardNumber = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  late final TextEditingController _email;
  final _phone = TextEditingController();
  final _otp = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: ref.read(authControllerProvider).value?.user.email ?? '');
  }

  @override
  void dispose() {
    for (final c in [_cardNumber, _expiry, _cvv, _email, _phone, _otp]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Checks what can be checked before bothering the PSP. Returns the
  /// first problem, in the order the fields appear.
  String? _validate() {
    if (_method == _Method.yape) {
      if (!RegExp(r'^9\d{8}$').hasMatch(_phone.text)) return 'Ingresa tu celular de 9 dígitos (empieza con 9).';
      if (!RegExp(r'^\d{6}$').hasMatch(_otp.text)) return 'El código de aprobación tiene 6 dígitos.';
      return null;
    }
    final digits = _cardNumber.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 13 || digits.length > 16 || !_luhn(digits)) return 'Revisa el número de tarjeta.';
    final expiry = RegExp(r'^(\d{2})/(\d{2})$').firstMatch(_expiry.text);
    final month = int.tryParse(expiry?.group(1) ?? '') ?? 0;
    final year = 2000 + (int.tryParse(expiry?.group(2) ?? '') ?? 0);
    final now = DateTime.now();
    if (month < 1 || month > 12 || DateTime(year, month + 1).isBefore(DateTime(now.year, now.month + 1))) {
      return 'Revisa la fecha de vencimiento (MM/AA).';
    }
    if (!RegExp(r'^\d{3,4}$').hasMatch(_cvv.text)) return 'El CVV tiene 3 o 4 dígitos.';
    if (!_email.text.contains('@')) return 'Ingresa un correo válido para el comprobante.';
    return null;
  }

  static bool _luhn(String digits) {
    var sum = 0;
    for (var i = 0; i < digits.length; i++) {
      var d = int.parse(digits[digits.length - 1 - i]);
      if (i.isOdd) {
        d *= 2;
        if (d > 9) d -= 9;
      }
      sum += d;
    }
    return sum % 10 == 0;
  }

  Future<String> _token() async {
    final publicKey = widget.payments.culqiPublicKey!;
    final tokenizer = ref.read(culqiTokenizerProvider);
    if (_method == _Method.yape) {
      return tokenizer.yapeToken(
        publicKey: publicKey,
        phone: _phone.text,
        otp: _otp.text,
        amountCents: widget.pack.priceCents,
      );
    }
    final parts = _expiry.text.split('/');
    return tokenizer.cardToken(
      publicKey: publicKey,
      cardNumber: _cardNumber.text,
      cvv: _cvv.text,
      expirationMonth: int.parse(parts[0]),
      expirationYear: 2000 + int.parse(parts[1]),
      email: _email.text.trim(),
    );
  }

  Future<void> _pay({String? simulatedToken}) async {
    if (_paying) return;
    if (simulatedToken == null) {
      final problem = _validate();
      if (problem != null) {
        setState(() => _error = problem);
        return;
      }
    }
    setState(() {
      _paying = true;
      _error = null;
    });
    try {
      final sourceId = simulatedToken ?? await _token();
      final result = await ref.read(creditsRepositoryProvider).purchase(
            purchaseId: _purchaseId,
            packId: widget.pack.id,
            sourceId: sourceId,
          );
      if (mounted) Navigator.of(context).pop(result);
    } on ApiException catch (e) {
      // 402: this attempt was declined and is closed — the next try is a
      // new purchase. Anything else (network, 503) keeps the same id.
      if (e.statusCode == 402) _purchaseId = _newPurchaseId();
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'No se pudo completar el pago. Revisa tu conexión e inténtalo de nuevo.');
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = _soles(widget.pack.priceCents);
    final simulated = widget.payments.isSimulated;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.pack.credits} créditos · $price', style: CercaText.lora(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              'Pago único. Los créditos no vencen.',
              style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary),
            ),
            const SizedBox(height: 16),
            if (simulated) ...[
              const _Notice(
                icon: Icons.science_outlined,
                text: 'Modo de prueba: no se pedirán datos ni se cobrará dinero real.',
              ),
            ] else ...[
              SegmentedButton<_Method>(
                segments: const [
                  ButtonSegment(value: _Method.card, label: Text('Tarjeta'), icon: Icon(Icons.credit_card)),
                  ButtonSegment(value: _Method.yape, label: Text('Yape'), icon: Icon(Icons.phone_iphone)),
                ],
                selected: {_method},
                onSelectionChanged: (s) => setState(() {
                  _method = s.first;
                  _error = null;
                }),
              ),
              const SizedBox(height: 14),
              if (_method == _Method.card) ..._cardFields() else ..._yapeFields(),
            ],
            if (_error != null) ...[
              const SizedBox(height: 10),
              Semantics(
                liveRegion: true,
                child: Text(_error!, style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaDangerText, height: 1.4)),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _paying ? null : () => _pay(simulatedToken: simulated ? 'tkn_fake_ok' : null),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
                child: Text(_paying ? 'Procesando…' : (simulated ? 'Simular pago de $price' : 'Pagar $price')),
              ),
            ),
            if (simulated)
              Center(
                child: TextButton(
                  onPressed: _paying ? null : () => _pay(simulatedToken: 'tkn_fake_declined'),
                  child: const Text('Simular pago rechazado'),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Pago procesado por Culqi. Cerca no guarda los datos de tu tarjeta.',
                  textAlign: TextAlign.center,
                  style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaTextSecondary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _cardFields() => [
        TextField(
          controller: _cardNumber,
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.creditCardNumber],
          textInputAction: TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d ]')), LengthLimitingTextInputFormatter(19)],
          decoration: const InputDecoration(labelText: 'Número de tarjeta'),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _expiry,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.creditCardExpirationDate],
                textInputAction: TextInputAction.next,
                inputFormatters: [_ExpiryFormatter()],
                decoration: const InputDecoration(labelText: 'Vence (MM/AA)'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _cvv,
                keyboardType: TextInputType.number,
                obscureText: true,
                autofillHints: const [AutofillHints.creditCardSecurityCode],
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                decoration: const InputDecoration(labelText: 'CVV'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(labelText: 'Correo para el comprobante'),
        ),
      ];

  List<Widget> _yapeFields() => [
        TextField(
          controller: _phone,
          keyboardType: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumberNational],
          textInputAction: TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],
          decoration: const InputDecoration(labelText: 'Celular registrado en Yape'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _otp,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
          decoration: const InputDecoration(
            labelText: 'Código de aprobación',
            helperText: 'Genéralo en tu app Yape: Menú → Código de aprobación.',
          ),
        ),
      ];
}

/// Inserts the slash in MM/AA as the user types.
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > 4 ? digits.substring(0, 4) : digits;
    final text = clipped.length > 2 ? '${clipped.substring(0, 2)}/${clipped.substring(2)}' : clipped;
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
