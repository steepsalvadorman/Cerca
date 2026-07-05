import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/cerca_controller.dart';
import '../../application/cerca_seed_data.dart';
import '../../domain/entities/chat_message.dart';
import '../widgets/back_circle_button.dart';
import '../widgets/cerca_text_styles.dart';
import '../widgets/monogram_avatar.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(cercaControllerProvider.notifier);
    ref.watch(cercaControllerProvider);
    final provider = controller.selectedProvider;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cercaBorder))),
              child: Row(
                children: [
                  BackCircleButton(onTap: () => context.go(RoutePaths.home)),
                  const SizedBox(width: 10),
                  MonogramAvatar(text: provider.mono, size: 34, borderRadius: 10, fontSize: 13),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(provider.name, style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(color: AppColors.cercaSuccessText, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 4),
                            Text('En camino', style: CercaText.sora(fontSize: 11, color: AppColors.cercaSuccessText)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                children: [
                  for (final message in CercaSeedData.chatMessages)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _ChatBubble(message: message),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      _QuickReplyChip('¿Cuánto falta?'),
                      SizedBox(width: 8),
                      _QuickReplyChip('Gracias'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.cercaBorder),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Escribe un mensaje…', style: CercaText.sora(fontSize: 13, color: AppColors.cercaTextMuted)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: AppColors.cercaPrimary, shape: BoxShape.circle),
                        child: const Text('→', style: TextStyle(color: Colors.white, fontSize: 15)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final ChatMessageEntry message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.from == ChatSender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          decoration: BoxDecoration(
            color: isUser ? AppColors.cercaPrimary : Colors.white,
            border: isUser ? null : Border.all(color: AppColors.cercaBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            message.text,
            style: CercaText.sora(fontSize: 13, height: 1.4, color: isUser ? Colors.white : AppColors.cercaTextPrimary),
          ),
        ),
      ),
    );
  }
}

class _QuickReplyChip extends StatelessWidget {
  const _QuickReplyChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cercaBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaTextSecondary)),
    );
  }
}
