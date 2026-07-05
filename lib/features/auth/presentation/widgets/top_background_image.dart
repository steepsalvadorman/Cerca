import 'package:flutter/material.dart';

class TopBackgroundImage extends StatelessWidget {
  const TopBackgroundImage({super.key, this.height = 280});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/background_new.png',
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      semanticLabel: 'Logo Cachuelitoo',
    );
  }
}
