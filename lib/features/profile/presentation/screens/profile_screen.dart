import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(featureName: 'Perfil');
  }
}
