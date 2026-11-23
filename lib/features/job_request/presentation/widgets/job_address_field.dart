import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../client/application/client_account_controller.dart';
import '../../../client_account/presentation/widgets/address_picker_sheet.dart';

/// "¿Dónde es el trabajo?" — picks one of the client's saved addresses, or
/// adds a new one through the map sheet (which also saves it to the
/// account). A job must not be created without this: the technician has
/// nowhere to go otherwise.
///
/// [value] is the address text sent to the backend as `address`.
class JobAddressField extends ConsumerWidget {
  const JobAddressField({
    super.key,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  final String? value;
  final ValueChanged<String> onChanged;
  final String? errorText;

  Future<void> _addNew(BuildContext context, WidgetRef ref) async {
    final result = await showAddressPicker(context);
    if (result == null) return;
    await ref
        .read(clientAccountControllerProvider.notifier)
        .addAddress(label: result.label, detail: result.detail);
    onChanged(result.detail);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(clientAccountControllerProvider);
    final addresses = accountAsync.value?.addresses ?? const [];

    // Preselect the first saved address so the common case costs no tap.
    if (value == null && addresses.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onChanged(addresses.first.detail));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Dónde es el trabajo?', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        if (accountAsync.isLoading && addresses.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))),
          )
        else
          for (final address in addresses)
            _AddressOption(
              label: address.label,
              detail: address.detail,
              selected: value == address.detail,
              onTap: () => onChanged(address.detail),
            ),
        // A typed-in address that is not (yet) in the saved list.
        if (value != null && value!.isNotEmpty && !addresses.any((a) => a.detail == value))
          _AddressOption(label: 'Nueva dirección', detail: value!, selected: true, onTap: () {}),
        Semantics(
          button: true,
          child: InkWell(
            onTap: () => _addNew(context, ref),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 48),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cercaDashedBorder),
              ),
              child: Text(
                addresses.isEmpty ? '+ Agregar dirección' : '+ Usar otra dirección',
                style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.cercaPrimary),
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: CercaText.sora(fontSize: 12, color: AppColors.cercaDangerText)),
        ],
      ],
    );
  }
}

class _AddressOption extends StatelessWidget {
  const _AddressOption({
    required this.label,
    required this.detail,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String detail;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        inMutuallyExclusiveGroup: true,
        checked: selected,
        button: true,
        label: '$label, $detail',
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: selected ? AppColors.cercaSurfaceTint : Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                      Text(label, style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(detail, style: CercaText.sora(fontSize: 12, color: AppColors.cercaTextSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
