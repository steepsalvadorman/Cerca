import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(featureName: 'Chat');
  }
}
